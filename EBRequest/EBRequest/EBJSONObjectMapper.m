//
//  EBJSONObjectMapper.m
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONObjectMapper.h"

@interface EBJSONObjectMapper () {
    Class           _class;
}

@end


@implementation EBJSONObjectMapper

- (id)initWithClass:(Class)class {
    if (self = [super init]) {
        _class = class;
    }
    
    return self;
}


+ (id)mapperWithClass:(Class)class {
    return [[[self alloc] initWithClass:class] autorelease];
}


- (id)objectFromDict:(NSDictionary *)dict {
    return nil;
}

#pragma mark - Public methods

- (Class)class {
    return _class;
}

@end
