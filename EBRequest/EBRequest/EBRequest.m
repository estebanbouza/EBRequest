//
//  EBRequest.m
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequest.h"


@implementation EBRequest

#pragma mark - Lifecycle

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _sourceURL = [url retain];
    }
    
    return self;
}

+ (id)requestWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (void)dealloc {    
    [_sourceURL release];
    
    [_completionBlock release];
    [_errorBlock release];
    
    [super dealloc];
}

#pragma mark - Empty behavior

- (BOOL)start {
    return NO;
}


- (void)stop {
    
}

@end
