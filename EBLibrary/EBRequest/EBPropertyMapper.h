//
//  EBArgumentMapper.h
//  EBRequest
//
//  Created by Esteban on 10/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>


/** The EBPropertyMapper class is used to associate the property names of a
 NSObject to the JSON property names.
 
 For example, for a class defined as
 
 `Person(name, age)`
 
 
 And a JSON defined as
 
 `{ "jname" : "peter", "jage" : 35 }`
 
 A mapper can be defined as:
 
 
 `propertyMapper` `=` `@[@"name" : @"jname", @"age" : @"jage"];`
 
 */
@interface EBPropertyMapper : NSObject

/** The class which this mapper is associated to.

 Note "class" is a reserved word.
 */
@property (nonatomic, retain) Class theClass;

/** Dictionary containing an equivalence between JSON and Class property names. */
@property (nonatomic, retain) NSDictionary *propertyMapper;


/** Returns a Property Mapper with the specified class and properties.
 @param aClass The class to be mapped.
 @param properties The class properties that must be mapped to another name.
 */
- (id)initWithClass:(Class)aClass properties:(NSDictionary *)properties;


/** See initWithClass:properties:
 @param aClass The class to be mapped.
 @param properties The class properties that must be mapped to another name.
*/
+ (id)mapperWithClass:(Class)aClass properties:(NSDictionary *)properties;

@end
