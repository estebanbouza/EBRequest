//
//  EBJSONObjectMapper.m
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONObjectMapper.h"

#import <objc/runtime.h>

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
    id object = [[_class alloc] init];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(_class, &count);
    
    for (int i = 0; i < count; i++) {
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];

        [object setValue:[dict objectForKey:propertyName] forKey:propertyName];
    }
    
    return [object autorelease];
}

#pragma mark - Public methods

- (Class)class {
    return _class;
}

@end
