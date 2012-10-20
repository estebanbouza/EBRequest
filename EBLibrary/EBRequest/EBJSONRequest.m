//
//  EBJSONRequest.m
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONRequest.h"
#import "EBJSONObjectMapper.h"

@interface EBJSONRequest() {
    NSURLConnection     *_urlConnection;
    NSURLRequest        *_urlRequest;
    
    NSMutableData       *_receivedData;
    
    BOOL                _isRunning;
}

@end

@implementation EBJSONRequest

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    
    if (self) {
        _urlRequest = [[NSURLRequest alloc] initWithURL:self.sourceURL];
        _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
        _receivedData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    // Stop running connection
    [_urlConnection cancel];
    
    [_urlRequest release];
    [_urlConnection release];
    
    [_receivedData release];
    [_JSONObjectMapper release];
    
    [super dealloc];
}



#pragma mark - Public methods

- (BOOL)start {
    _isRunning = YES;
    [_urlConnection start];
    
    return YES;
}

- (void)stop {
    _isRunning = NO;
    [_urlConnection cancel];
}

- (BOOL)isRunning {
    return _isRunning;
}

#pragma mark - Connection data delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (!_isRunning) {
        return;
    }
    
    _isRunning = NO;
    
    if ([NSThread isMainThread]) {
        self.errorBlock(error);
    } else {
        // Avoid over-retaining error
        __block typeof(error) errorParam = error;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorBlock(errorParam);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (!_isRunning) {
        return;
    }
    
    _isRunning = NO;
    
    // Map the result to a JSON
    NSError *error;
    id mappedResult = [NSJSONSerialization JSONObjectWithData:_receivedData options:0 error:&error];
    
    // If there are classes to map, then do it
    if (self.JSONObjectMapper) {
        mappedResult = [_JSONObjectMapper objectFromJSON:mappedResult];
    }
    
    if ([NSThread isMainThread]) {
        self.completionBlock(mappedResult);
    }
    
    else {
        // Avoid over-retaining _receivedData inside block
        __block typeof(mappedResult) __mappedResult = mappedResult;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.completionBlock(__mappedResult);
        });
    }
}

@end
