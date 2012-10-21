//
//  EBImageRequest.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBImageRequest.h"

@interface EBImageRequest () <EBRequestDelegate> {
    EBDataRequest *_dataRequest;
}

@end

@implementation EBImageRequest

#pragma Lifecycle

- (id)initWithURL:(NSURL *)url {
    
    if (self = [super initWithURL:url]) {
        
        _dataRequest = [[EBDataRequest alloc] initWithURL:url];
        _dataRequest.runLoopMode = NSRunLoopCommonModes;
        _dataRequest.completionBlock = [self imageCompletionBlock];
        _dataRequest.errorBlock = [self imageErrorBlock];
        _dataRequest.delegate = self;
        
    }
    
    return self;
}

+ (id)requestWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (void)dealloc {
    [_dataRequest release];
    
    [super dealloc];
}

#pragma Handlers

- (EBCompletionBlock)imageCompletionBlock {
    
    __block typeof(self) this = self;
    
    EBCompletionBlock block = ^(NSData *data){

        if (data == nil) {
            this.errorBlock([NSError errorWithDomain:@"No data downloaded" code:-1 userInfo:nil]);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image == nil) {
            this.errorBlock([NSError errorWithDomain:@"Couldn't create image" code:-1 userInfo:nil]);
            return;
        }
        
        this.completionBlock(image);
        
    };
    
    return [[block copy] autorelease];
}

- (EBErrorBlock)imageErrorBlock {

    __block typeof(self) this = self;

    EBErrorBlock block = ^(NSError *error) {
        this.errorBlock(error);
    };
    
    return [[block copy] autorelease];
}

#pragma mark - Data Request delegate

- (void)request:(EBRequest *)request progressChanged:(float)progress {
    if (request == _dataRequest) {
        [self notifyProgressChange:progress];
    }
}

- (void)notifyProgressChange:(float)progress {
    if ([self.delegate respondsToSelector:@selector(request:progressChanged:)]) {
        [self.delegate request:self progressChanged:progress];
    }
}

- (void)requestDidStart:(EBRequest *)request {
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }
}

- (void)requestDidFinish:(EBRequest *)request {
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [self.delegate requestDidFinish:self];
    }
}


#pragma mark - Public methods

- (BOOL)start {
    return [_dataRequest start];
}

- (void)stop {
    [_dataRequest stop];
}

- (BOOL)isRunning {
    return _dataRequest.isRunning;
}



@end
