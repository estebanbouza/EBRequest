//
//  EBRuntimeUtils.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRuntimeUtils.h"

@implementation EBRuntimeUtils

+ (NSMutableSet *)propertyNamesForClass:(Class)class {
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableSet *propertyNames = [NSMutableSet setWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyName];
    }
    
    free(properties);
    
    return propertyNames;
}

@end
