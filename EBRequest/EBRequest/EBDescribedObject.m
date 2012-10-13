//
//  EBDescribedObject.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBDescribedObject.h"
#import <objc/runtime.h>


@implementation EBDescribedObject

- (NSString *)description {
    NSMutableString *result = [NSMutableString string];
    
    // Sort properties by name:
    
    NSMutableSet *properties = [self propertyNamesForClass:[self class]];
    NSArray *sortedProperties = [[properties allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *) obj2];
    }];
    
    for (NSString *propName in sortedProperties) {
        [result appendFormat:@"%@: %@, ", propName, [self valueForKey:propName]];
    }

    return result;
}

- (NSMutableSet *)propertyNamesForClass:(Class)class {
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    NSMutableSet *propertyNames = [NSMutableSet setWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [propertyNames addObject:propertyName];
    }
    
    return propertyNames;
}

@end
