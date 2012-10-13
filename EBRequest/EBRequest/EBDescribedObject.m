//
//  EBDescribedObject.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBDescribedObject.h"
#import "EBRuntimeUtils.h"

@implementation EBDescribedObject

- (NSString *)description {
    NSMutableString *result = [NSMutableString string];
    
    // Sort properties by name
    NSMutableSet *properties = [EBRuntimeUtils propertyNamesForClass:[self class]];
    NSArray *sortedProperties = [[properties allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSInteger i = 0; i < sortedProperties.count; i++) {
        NSString *propName = sortedProperties[i];
        NSString *appendFormat = i == sortedProperties.count - 1 ? @"%@: {%@}" : @"%@: {%@}, ";
        
        [result appendFormat:appendFormat, propName, [self valueForKey:propName]];
    }

    return result;
}



@end
