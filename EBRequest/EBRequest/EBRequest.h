//
//  EBRequest.h
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EBCompletionBlock)(id responseData);
typedef void(^EBErrorBlock) (NSError *error);

/// Represents an abstract request
@interface EBRequest : NSObject

/// Source URL
@property (atomic, retain) NSURL *sourceURL;

/// Completion block called when the request is finished correctly. The completion block is always executed in the main thread.
@property (atomic, copy) EBCompletionBlock completionBlock;

/// Error block called when the request fails. The error block is always executed in the main thread.
@property (atomic, copy) EBErrorBlock errorBlock;

/// Optional property. When set, this run loop mode will be assigned to the internal NSURLConnection.
@property (nonatomic, retain) NSString *runLoopMode;

/// Specifies if the current request is running
@property (nonatomic, readonly) BOOL isRunning;

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