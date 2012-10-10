//
//  EBArgumentMapper.m
//  EBRequest
//
//  Created by Esteban on 10/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBPropertyMapper.h"

@implementation EBPropertyMapper


- (id)initWithClass:(Class)aClass properties:(NSDictionary *)properties {
    self = [super init];
    
    if (self) {
        self.theClass = aClass;
        self.propertyMapper = properties;
    }
    
    return self;
}

+ (id)mapperWithClass:(Class)aClass properties:(NSDictionary *)properties {
    return [[self alloc] initWithClass:aClass properties:properties];
}


- (void)dealloc {
    [_theClass release];
    [_propertyMapper release];
    
    [super dealloc];
}

@end
