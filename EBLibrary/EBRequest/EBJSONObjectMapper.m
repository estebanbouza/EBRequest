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

#pragma mark - Implementation

- (id)objectFromJSON:(id)json {
    
    if (isDictionary(json)) {
        Class class = [self susceptibleClassForDict:json];
        
        return [self mappedDictionary:json toClass:class];

    } else if (isArray(json)) {
        NSMutableArray *result = [NSMutableArray array];
        for (id anElement in (NSArray *)json) {
            [result addObject:[self objectFromJSON:anElement]];
        }
        return result;
    }
    
    return nil;
}

- (id)mappedDictionary:(NSDictionary *)feedDict toClass:(Class)class {
    id object = [[class alloc] init];
    
    unsigned int count;
    
    // Read object's properties
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // If there's a mapped property name, use it
        NSString *mappedPropertyName = [self mappedPropertyName:propertyName forClass:class];
        mappedPropertyName = mappedPropertyName ? mappedPropertyName : propertyName;
        
        // Value to be set in the new object
        id feedValue = [feedDict objectForKey:mappedPropertyName];
        
        if (feedValue == nil) {
            // Key not defined. Skipping
            continue;
        }
        
        // Get property class
        NSString *propertyClassName = [NSString stringWithCString:getPropertyType(property) encoding:NSUTF8StringEncoding];
        Class propertyClass = NSClassFromString(propertyClassName);
        
        // If the property class is a dictionary or an array, map it recursively
        if (isDictionary(feedValue) ||
            isArray(feedValue)) {
            feedValue = [self objectFromJSON:feedValue];
        }
        
        // Conditional setters.
        // In case of date, only unix timestamps are valid
        else if ([propertyClass isSubclassOfClass:[NSDate class]]) {
            feedValue = [NSDate dateWithTimeIntervalSince1970:[[feedDict objectForKey:propertyName] doubleValue]];
        } else if ([propertyClassName isEqualToString:kBOOLTypeString]) {
            feedValue = [feedDict objectForKey:propertyName];
        }
        else if (propertyClass == nil ) {
            DLog(@"Warning: Could not determine class of property %@. Trying scalar ", propertyName);
        }
        
        [object setValue:feedValue forKey:propertyName];
    }
    
    free(properties);
    
    return [object autorelease];
}


/** @param propertyName The property name to search.
 @param class The class to be searched.
 @returns The mapped property name if found. Nil otherwise. */
- (NSString *)mappedPropertyName:(NSString *)propertyName forClass:(Class)class {
    
    for (EBPropertyMapper *propertyMapper in self.propertyMappers) {
        if (propertyMapper.theClass == class) {
            return [propertyMapper.propertyMapper objectForKey:propertyName];
        }
    }
    
    return nil;
}

/// @returns The most susceptible class for the dict or nil if not found at all.
/// @param dictionary The dictionary to be linked to a class.
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

/** @param class The class to be analyzed
 @returns The property names for a specified class, using the value of propertyMapper by default */
- (NSMutableSet *)propertyNamesForClass:(Class)class {

    unsigned int count;

    objc_property_t *properties = class_copyPropertyList(class, &count);

    NSMutableSet *propertyNames = [NSMutableSet setWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *mappedPropertyName = [self mappedPropertyName:propertyName forClass:class];
        
        mappedPropertyName = mappedPropertyName ? mappedPropertyName : propertyName;
        
        [propertyNames addObject:mappedPropertyName];
    }
    
    free(properties);
    
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
