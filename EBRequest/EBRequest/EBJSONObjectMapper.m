//
//  EBJSONObjectMapper.m
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONObjectMapper.h"
#import <objc/runtime.h>

static const char *kBOOLType = "c";
static const char *kTypeUnknown = "unk";
#define kBOOLTypeString [NSString stringWithCString:kBOOLType encoding:NSUTF8StringEncoding]

@interface EBJSONObjectMapper () {
    NSArray         *_classes;
}

@end


@implementation EBJSONObjectMapper

- (id)initWithClass:(Class)class {
    if (self = [super init]) {
        _classes = [[NSArray arrayWithObject:class] retain];
    }
    
    return self;
}

- (id)initWithClasses:(NSArray *)classes {
    if (self = [super init]) {
        _classes = [classes copy];
    }
    
    return self;
}

+ (id)mapperWithClass:(Class)class {
    return [[[self alloc] initWithClass:class] autorelease];
}

+ (id)mapperWithClasses:(NSArray *)classes {
    return [[[self alloc] initWithClasses:classes] autorelease];
}



- (id)objectFromJSON:(id)json {
    
    if (isDictionary(json)) {
        Class class = [self susceptibleClassForDict:json];
        
        return [self mappedDictionary:json toClass:class];

    } else if (isArray(json)) {
        for (id anElement in (NSArray *)json) {
            [self objectFromJSON:anElement];
        }
    }
    
    return nil;
}

- (id)mappedDictionary:(NSDictionary *)dict toClass:(Class)class {
    id object = [[class alloc] init];
    
    unsigned int count;
    
    // Read object's properties
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // Value to be set in the new object
        id value = [dict objectForKey:propertyName];
        
        if (value == nil) {
            DLog(@"Key not defined: %@. Skipping", propertyName);
            continue;
        }
        
        // Get property class
        NSString *propertyClassName = [NSString stringWithCString:getPropertyType(property) encoding:NSUTF8StringEncoding];
        Class propertyClass = NSClassFromString(propertyClassName);
        
        // If the property class is a dictionary, map it recursively
        if (isDictionary(value)) {
            Class bestClass = [self susceptibleClassForDict:value];
            
            value = [self mappedDictionary:value toClass:bestClass];
        }
        
        // If the property class is an array, map it also recursively
        else if (isArray(value)) {
            NSMutableArray *elements = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];
            
            for (id anElement in (NSArray *)value) {
                [elements addObject:[self objectFromJSON:anElement]];
            }
            
            value = elements;
        }
        
        // Conditional setters.
        // In case of date, only unix timestamps are valid
        else if ([propertyClass isSubclassOfClass:[NSDate class]]) {
            value = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:propertyName] doubleValue]];
        } else if ([propertyClassName isEqualToString:kBOOLTypeString]) {
            value = [dict objectForKey:propertyName];
        }
        else if (propertyClass == nil ) {
            DLog(@"Warning: Could not determine class of property %@. Trying scalar ", propertyName);
        }
        
        [object setValue:value forKey:propertyName];
    }
    
    free(properties);
    
    return [object autorelease];
}

/// @returns The most susceptible class for the dict or nil if not found at all.
- (Class)susceptibleClassForDict:(NSDictionary *)dictionary {
    Class theClass = nil;
    NSInteger maxCommonProperties = 0;
    
    // Iterate over all the possible classes
    for (Class aClass in _classes) {
        
        // Get all the class property names
        NSMutableSet *classProperties = [self propertyNamesForClass:aClass];
        
        // Get all the dictionary keys
        NSSet *dictKeys = [NSSet setWithArray:[dictionary allKeys]];
        
        // Intersect both sets
        [classProperties intersectSet:dictKeys];
        
        NSInteger commonProperties = [classProperties count];
        
        if (commonProperties > maxCommonProperties) {
            theClass = aClass;
            maxCommonProperties = commonProperties;
        }
    }
    
    return theClass;
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
                if (strlen(attribute) > 7) {
                result = (const char *)[[NSData dataWithBytes: (attribute + 3)
                                                       length: strlen(attribute) - 4] bytes];
                    
                } else if(strlen(attribute) >= 2 &&
                          !strcmp(&attribute[1], kBOOLType)) {
                    result = kBOOLType;
                } else {
                    result = kTypeUnknown;
                }
                break;
        }
    }
    return result;
}


#pragma mark - Public methods

- (NSArray *)classes {
    return [[_classes copy] autorelease];
}

@end
