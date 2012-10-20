//
//  ResponseData.h
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageEntry.h"

@interface ImageResponseData : NSObject

@property (nonatomic, strong) NSArray *results;
// This property is not needed. Defined just for clarity.
@property (nonatomic, strong) id cursor;

@end
