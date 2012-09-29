//
//  EBRequest.h
//  EBRequest
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EBCompletionBlock)(id responseData);
typedef void(^EBErrorBlock) (NSError *error);

/// Represents an abstract request
@interface EBRequest : NSObject

/// Source URL
@property (atomic, readonly) NSURL *sourceURL;

/// Completion block called when the request is finished correctly.
@property (atomic, copy) EBCompletionBlock completionBlock;

/// Error block called when the request fails
@property (atomic, copy) EBErrorBlock errorBlock;


/// Creates a new request with the specified URL. Not started until start is called.
/// @param url URL for the request
+ (id)requestWithURL:(NSURL *)url;

/// Creates a new request with the specified URL. Not started until start is called.
/// @param url URL for the request.
- (id)initWithURL:(NSURL *)url;

/// Starts an asynchronous request
/// @returns YES if the request could be started. NO otherwise.
- (BOOL)start;

/// Stops an asynchronous request.
- (void)stop;


@end
