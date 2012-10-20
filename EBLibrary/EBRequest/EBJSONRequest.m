//
//  EBJSONRequest.m
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONRequest.h"

@interface EBJSONRequest() {
    NSURLConnection     *_urlConnection;
    NSURLRequest        *_urlRequest;
    
    NSMutableData       *_receivedData;
    
    BOOL                _isRunning;
    
    long long           _expectedContentLength;
}

@end

@implementation EBJSONRequest

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    
    if (self) {
        _expectedContentLength = -1;
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
    _urlRequest = [[NSURLRequest alloc] initWithURL:self.sourceURL];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
    _receivedData = [[NSMutableData alloc] init];
    
    _isRunning = YES;
    [_urlConnection start];
    
    return YES;
}

- (void)stop {
    [_urlConnection cancel];
    _isRunning = NO;
    
    [_urlRequest release], _urlRequest = nil;
    [_urlConnection release], _urlConnection = nil;
    [_receivedData release], _receivedData = nil;
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
    
    [self notifyProgressChange];
    
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

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    
    if (![response respondsToSelector:@selector(statusCode)]) {
        DLog(@"Warning. Cannot access [response statusCode]. Maybe the request isn't http?");
    }
    else if([response statusCode] == 200) {
        _expectedContentLength = [response expectedContentLength];
        
        [self notifyProgressChange];
    }
}


#pragma mark - Internal

- (void)notifyProgressChange {
    if ([self.delegate respondsToSelector:@selector(request:progressChanged:)]) {
        float progress = ((float) [_receivedData length] / (float) _expectedContentLength);
        
        [self.delegate request:self progressChanged:progress];
    }
}

@end
