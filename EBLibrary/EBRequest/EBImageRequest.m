//
//  EBImageRequest.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBImageRequest.h"

@interface EBImageRequest () {
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
