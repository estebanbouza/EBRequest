//
//  EBDescribedObject.h
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

/** EBDescribedObject subclasses have a default implementation for -description method.
    
 When calling -description in a EBDescribedObject subclass, all the properties will be printed in the console. See -description.
 
 */
@interface EBDescribedObject : NSObject

/** The description value of all the properties.
 
 The format for printing is:
 
 - propertyName: {propertyValue}, propertyName: {propertyValue}, etc...
 - All properties are sorted alphabetically.
 
 */
- (NSString *)description;

@end
