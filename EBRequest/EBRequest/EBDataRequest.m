//
//  EBRequest.m
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBDataRequest.h"

@interface EBDataRequest() <NSURLConnectionDataDelegate> {    
    NSURLConnection     *_urlConnection;
    NSURLRequest        *_urlRequest;
    
    NSMutableData       *_receivedData;
    
    BOOL                _shouldBeRunning;
}

@end

@implementation EBDataRequest

#pragma mark - Lifecycle

- (void)dealloc {
    // Stop running connection
    [_urlConnection cancel];
    
    [_urlRequest release];
    [_urlConnection release];
        
    [_receivedData release];
    
    [super dealloc];
}



#pragma mark -

- (BOOL)start {
    _urlRequest = [[NSURLRequest alloc] initWithURL:self.sourceURL];
    
    _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self startImmediately:NO];
    
    _receivedData = [[NSMutableData alloc] init];
    
    _shouldBeRunning = YES;
    [_urlConnection start];
    return YES;
}

- (void)stop {
    _shouldBeRunning = NO;
    [_urlConnection cancel];
}

#pragma mark - Connection data delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if (!_shouldBeRunning) {
        return;
    }
    
    _shouldBeRunning = NO;
    
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
    
    if (!_shouldBeRunning) {
        return;
    }
    
    _shouldBeRunning = NO;
    
    if ([NSThread isMainThread]) {
        self.completionBlock(_receivedData);
    }
    
    else {
        // Avoid over-retaining _receivedData inside block
        __block typeof(_receivedData) data = _receivedData;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.completionBlock(data);
        });
    }
}


@end
