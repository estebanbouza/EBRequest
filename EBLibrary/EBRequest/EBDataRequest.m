//
//  EBRequest.m
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBDataRequest.h"
#import "EBRequest+PrivateMethods.h"

@interface EBDataRequest() <NSURLConnectionDataDelegate> {    
    NSURLConnection     *_urlConnection;
    NSURLRequest        *_urlRequest;
    
    NSMutableData       *_receivedData;
    
    BOOL                _isRunning;
    
    long long           _expectedContentLength;
}

@end

@implementation EBDataRequest

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    
    if (self) {
        _expectedContentLength = -1;
    }
    
    return self;
}


+ (id)requestWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}


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

    if (self.runLoopMode) {
        [_urlConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:self.runLoopMode];
    }
    
    _isRunning = YES;
    [_urlConnection start];
    
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }
    
    return YES;
}

- (void)stop {
    [_urlConnection cancel];
    _isRunning = NO;
    
    [_urlRequest release], _urlRequest = nil;
    [_urlConnection release], _urlConnection = nil;
    [_receivedData release], _receivedData = nil;
    
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
    
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
        __block typeof(self) this = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            this.errorBlock(errorParam);
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_receivedData appendData:data];
    
    [self notifyProgressChange:[_receivedData length] expected:_expectedContentLength];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (!_isRunning) {
        return;
    }
    
    _isRunning = NO;
    
    if ([NSThread isMainThread]) {
        self.completionBlock(_receivedData);
    }
    
    else {
        // Avoid over-retaining _receivedData and self inside block
        __block typeof(_receivedData) data = _receivedData;
        __block typeof(self) this = self;

        dispatch_sync(dispatch_get_main_queue(), ^{
            this.completionBlock(data);
        });
    }
    
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    
    // If progress doesn't need to be tracked, return.
    if (![self.delegate respondsToSelector:@selector(request:progressChanged:)]) {
        return;
    }
    
    // Not possible to access status code. Return.
    if (![response respondsToSelector:@selector(statusCode)]) {
        [self notifyCannotTrackProgress];
        return;
    }
    
    // The request didn't went well. Return.
    else if ([response statusCode] != 200) {
        [self notifyCannotTrackProgress];
        return;
    }
    
    // Everything ok. Get contentLength
    _expectedContentLength = [response expectedContentLength];
    
    // Content lenght invalid? Cannot track progress.
    if (_expectedContentLength == NSURLResponseUnknownLength) {
        [self notifyCannotTrackProgress];
        return;
    }
    
    [self notifyProgressChange:0ll expected:_expectedContentLength];
}

@end
