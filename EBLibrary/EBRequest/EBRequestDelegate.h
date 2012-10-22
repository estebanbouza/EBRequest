//
//  EBRequestDelegate.h
//  EBLibrary
//
//  Created by Esteban on 20/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

static const float kEBProgressUnknown;

@class EBRequest;

@protocol EBRequestDelegate <NSObject>

@optional

/** Specifies the current progress of this request.
 @param request The request being used.
 @param progress The current progress between `0.0` and `1.0`.
 
 In some cases the progress cannot be changed. See requestCannotReceiveProgressUpdates:
 */
- (void)request:(EBRequest *)request progressChanged:(float)progress;

/**
 This delegate method will be called when there's no possibility to track the progress of a request.
 The request progress is based in the server response, and sometimes the server may not respond valid data. In that case, this delegate method will be called.
 */
- (void)requestCannotReceiveProgressUpdates:(EBRequest *)request;

/** 
 Called when the request starts. 
 */
- (void)requestDidStart:(EBRequest *)request;

/** 
 Called when the request finishes. This could be after a successful completion, error or manual stop.
 */
- (void)requestDidFinish:(EBRequest *)request;

@end
