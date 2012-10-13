//
//  ResponseData.h
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Entry.h"

@interface ResponseData : NSObject

@property (nonatomic, strong) NSString  *query;
@property (nonatomic, strong) NSArray   *entries;

@end
