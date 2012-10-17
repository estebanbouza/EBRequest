//
//  EBImageRequest.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBImageRequest.h"

@interface EBImageRequest () {
    EBDataRequest *_request;
}

@end

@implementation EBImageRequest

#pragma Lifecycle

- (id)initWithURL:(NSURL *)url {
    
    if (self = [super initWithURL:url]) {
        
        _request = [[EBDataRequest alloc] initWithURL:url];
        _request.runLoopMode = NSRunLoopCommonModes;
        _request.completionBlock = [self imageCompletionBlock];
        _request.errorBlock = [self imageErrorBlock];
        
    }
    
    return self;
}

+ (id)requestWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (void)dealloc {
    [_request release];
    
    [super dealloc];
}

#pragma Handlers

- (EBCompletionBlock)imageCompletionBlock {
    
    id block = ^(NSData *data){

        if (data == nil) {
            self.errorBlock([NSError errorWithDomain:@"No data downloaded" code:-1 userInfo:nil]);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (image == nil) {
            self.errorBlock([NSError errorWithDomain:@"Couldn't create image" code:-1 userInfo:nil]);
            return;
        }
        
        self.completionBlock(image);
        
    };
    
    return [[block copy] autorelease];
}

- (EBErrorBlock)imageErrorBlock {
    id block = ^(NSError *error) {
        self.errorBlock(error);
    };
    
    return [[block copy] autorelease];
}


#pragma mark - Public methods

- (BOOL)start {
    return [_request start];
}

- (void)stop {
    [_request stop];
}


@end
