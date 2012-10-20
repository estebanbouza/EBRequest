//
//  EBRequestDelegate.h
//  EBLibrary
//
//  Created by Esteban on 20/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EBRequest;

@protocol EBRequestDelegate <NSObject>

@optional

/*** Specifies the current progress of this request.
 @params request The request being used.
 @params progress The current progress between `0.0` and `1.0`.
 */
- (void)request:(EBRequest *)request progressChanged:(float)progress;

@end
