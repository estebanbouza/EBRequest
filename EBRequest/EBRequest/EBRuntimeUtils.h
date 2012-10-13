//
//  EBRuntimeUtils.h
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface EBRuntimeUtils : NSObject

+ (NSMutableSet *)propertyNamesForClass:(Class)class;

@end
