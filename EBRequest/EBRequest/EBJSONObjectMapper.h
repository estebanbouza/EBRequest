//
//  EBJSONObjectMapper.h
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Maps a NSDictionary from a JSON to a NSObject
@interface EBJSONObjectMapper : NSObject

/// Mapper's classes for this object
@property (atomic, readonly) NSArray *classes;

/// Creates a mapper instance for the specified class
/// @param class The class to be mapped to
- (id)initWithClass:(Class)class;

- (id)initWithClasses:(NSArray *)classes;

/// Creates an autoreleased mapper for the specified class. See initWithClass:
/// @param class The class to be mapped to
+ (id)mapperWithClass:(Class)class;

+ (id)mapperWithClasses:(NSArray *)classes;

/// Maps a NSDictionary to a custom class.
/// @param dict The array or dictionary with the key-values representing the ivars of the object.
/// @returns an object of the specified class (See initWithClass:)
- (id)objectFromDict:(id)dict;

@end