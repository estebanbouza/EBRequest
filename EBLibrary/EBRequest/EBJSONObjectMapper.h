//
//  EBJSONObjectMapper.h
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPropertyMapper.h"

/// Maps a NSDictionary from a JSON to a NSObject.
@interface EBJSONObjectMapper : NSObject

/// Mapper's classes for this object
@property (nonatomic, readonly) NSArray *classes;

/// Optional. A list of EBPropertyMapper between NSObject property names and JSON fields. See EBPropertyMapper.
@property (nonatomic, retain) NSArray *propertyMappers;

/// Creates a mapper instance for the specified class.
/// @param class The class to be mapped to
- (id)initWithClass:(Class)class;

/// Creates a mapper instance with several possible clases.
/// @param classes The possible classes to map to
- (id)initWithClasses:(NSArray *)classes;

/** Creates a mapper instance with several possible classes and property mappers.
@param classes The possible classes to map to.
 @param propertyMappers A list of EBPropertyMapper between NSObject property names and JSON fields. See EBPropertyMapper.
*/
- (id)initWithClasses:(NSArray *)classes propertyMappers:(NSArray *)propertyMappers;

/// Creates an autoreleased mapper for the specified class. See initWithClass:
/// @param class The class to be mapped to
+ (id)mapperWithClass:(Class)class;

/// Creates an autoreleased mapper for the specified classes. See initWithClasses:
/// @param classes The possible classes to map to.
+ (id)mapperWithClasses:(NSArray *)classes;

/** Creates an autoreleased mapper for the specified classes and property mappers. See initWithClasses:propertyMappers:
 */
+ (id)mapperWithClasses:(NSArray *)classes propertyMappers:(NSArray *)propertyMappers;

/// Maps a NSDictionary to a custom class.
/// @param dict The array or dictionary with the key-values representing the ivars of the object.
/// @returns an object of the specified class (See initWithClass:).
- (id)objectFromJSON:(id)dict;


@end
