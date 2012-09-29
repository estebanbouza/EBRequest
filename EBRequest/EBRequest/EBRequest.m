//
//  EBRequest.m
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequest.h"

@interface EBRequest()<NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURL               *_sourceURL;
    
    NSURLConnection     *_urlConnection;
    NSURLRequest        *_urlRequest;
    
    NSMutableData       *_receivedData;
}

@end

@implementation EBRequest

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _sourceURL = [url retain];
    }
    
    return self;
}

- (void)dealloc {
    [_sourceURL release];
    [_completionBlock release];
    [_errorBlock release];
    [_receivedData release];
    
    [super dealloc];
}

#pragma mark - 

- (BOOL)start {
    _urlRequest = [[NSURLRequest alloc] initWithURL:_sourceURL];
    
    _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
    
    _receivedData = [[NSMutableData alloc] init];

    return YES;
}

#pragma mark - 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"");
    

    if ([NSThread isMainThread]) {
        _errorBlock(error);
    } else {
        // Avoid over-retaining error
        __block typeof(error) errorParam = error;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _errorBlock(errorParam);
        });
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    DLog(@"");
    
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"");
    
    if ([NSThread isMainThread]) {
        _completionBlock(connection);
    }
    
    else {
        // Avoid over-retaining _receivedData inside block
        __block typeof(_receivedData) data = _receivedData;

        dispatch_sync(dispatch_get_main_queue(), ^{
            _completionBlock(data);
        });
    }
}


@end
