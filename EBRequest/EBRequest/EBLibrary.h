//
//  EBRequest.h
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EBRequest.h"
#import "EBDataRequest.h"
#import "EBJSONRequest.h"

#import "EBJSONObjectMapper.h"
#import "EBPropertyMapper.h"

#import "EBInfo.h"
#import "EBGitVersion.h"

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
