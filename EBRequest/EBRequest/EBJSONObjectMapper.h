//
//  EBJSONObjectMapper.h
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Maps a NSDictionary from a JSON to a NSObject.
@interface EBJSONObjectMapper : NSObject

/// Mapper's classes for this object
@property (nonatomic, readonly) NSArray *classes;

/** Dictionary containing an/ equivalence between JSON and Class property names.
 

For example, for a class defined as 
    Person(name, age)
And a JSON defined as
 
    { "jname" : "peter", "jage" : 35 }
A mapper can be defined as:
    argumentMapper = [@"name" : @"jname", @"age" : @"jage"];
 */
@property (nonatomic, retain) NSDictionary *argumentMapper;

/// Creates a mapper instance for the specified class.
/// @param class The class to be mapped to
- (id)initWithClass:(Class)class;

/// Creates a mapper instance with several possible clases.
/// @param classes The possible classes to map to
- (id)initWithClasses:(NSArray *)classes;

/// Creates an autoreleased mapper for the specified class. See initWithClass:
/// @param class The class to be mapped to
+ (id)mapperWithClass:(Class)class;

/// Creates an autoreleased mapper for the specified classes. See initWithClasses:
/// @param classes The possible classes to map to.
+ (id)mapperWithClasses:(NSArray *)classes;

/// Maps a NSDictionary to a custom class.
/// @param dict The array or dictionary with the key-values representing the ivars of the object.
/// @returns an object of the specified class (See initWithClass:).
- (id)objectFromJSON:(id)dict;


@end
