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
- (void)request:(EBRequest *)request changedProgressTo:(float)progress;

@end
