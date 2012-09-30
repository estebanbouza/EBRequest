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
    
    // Read object's properties
    objc_property_t *properties = class_copyPropertyList(_class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        Class propertyClass = NSClassFromString([NSString stringWithCString:getPropertyType(property) encoding:NSUTF8StringEncoding]);
        
        // Value to be set in the new object
        id value = [dict objectForKey:propertyName];
        if ([propertyClass isSubclassOfClass:[NSDate class]]) {
            value = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:propertyName] doubleValue]];
        }
        else if (propertyClass == nil ) {
            DLog(@"Warning: Could not determine class of property %@", propertyName);
        }
        
        [object setValue:value forKey:propertyName];
    }
    
    free(properties);
    
    return [object autorelease];
}


static const char* getPropertyType(objc_property_t property) {
    
    const char *result = "@";
    
    // Copy property attributes into a writeable buffer:
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    
    // Scan the comma-delimited sections of the string:
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        switch (attribute[0]) {
            case 'T':
                // 3 = strlen(,@")
                // 4 = strlen(,"') + strlen(")
                result = (const char *)[[NSData dataWithBytes: (attribute + 3)
                                                       length: strlen(attribute) - 4] bytes];
                break;
        }
    }
    return result;
}


#pragma mark - Public methods

- (Class)class {
    return _class;
}

@end
