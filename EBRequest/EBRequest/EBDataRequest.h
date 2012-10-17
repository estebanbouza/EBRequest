//
//  EBRequest.h
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBRequest.h"

/// EBDataRequest will return NSData objects in the completion block
@interface EBDataRequest : EBRequest

/// Optional property. When set, this run loop mode will be assigned to the internal NSURLConnection.
@property (nonatomic, retain) NSString *runLoopMode;

@end
