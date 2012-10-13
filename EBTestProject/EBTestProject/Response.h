//
//  Response.h
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseData.h"

@interface Response : NSObject

@property (nonatomic, strong) ResponseData  *responseData;
@property (nonatomic, strong) NSNumber      *responseStatus;
@property (nonatomic, strong) NSString      *responseDetails;

@end
