//
//  EBRequestDelegateTests.m
//  EBLibrary
//
//  Created by Esteban on 21/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequestDelegateTests.h"

@interface EBRequestDelegateTests () <EBRequestDelegate> {
    BOOL _zeroFound;
    BOOL _oneFound;
    BOOL _canTrackProgress;

    BOOL _completionExecuted;
    
    dispatch_semaphore_t _semaphore;
}

@end

@implementation EBRequestDelegateTests

- (void)setUp {
    [super setUp];
    
    _semaphore = dispatch_semaphore_create(0);

    _completionExecuted = NO;
    
    _zeroFound = NO;
    _oneFound = NO;
    _canTrackProgress = YES;
}

- (void)tearDown {
    dispatch_release(_semaphore);

    [super tearDown];
}


- (void)testDataProgress {

    EBDataRequest *dataRequest = [EBDataRequest requestWithURL:[NSURL URLWithString:@"http://static.googleusercontent.com/external_content/untrusted_dlcp/www.google.com/en//websiteoptimizer/techieguide.pdf"]];
    
    dataRequest.delegate = self;
    
    dataRequest.completionBlock = ^(id data) {
        _completionExecuted = YES;
        dispatch_semaphore_signal(_semaphore);
    };
    
    [dataRequest start];
    
    while (dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
    }
    
    STAssertTrue(_zeroFound, @"Progress must start in 0.0");
    STAssertTrue(_oneFound, @"Progress must end in 1.0");
    STAssertTrue(_completionExecuted, nil);
}

- (void)testImageProgress {
    
    EBImageRequest *imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"https://lh4.googleusercontent.com/-v0soe-ievYE/AAAAAAAAAAI/AAAAAAAAs7Y/yFVd0T5kw-o/photo.jpg"]];
    
    imageRequest.delegate = self;
        
    imageRequest.completionBlock = ^(id data) {
        _completionExecuted = YES;
        dispatch_semaphore_signal(_semaphore);
    };
    
    [imageRequest start];
    
    while (dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
    }
    
    STAssertTrue(_zeroFound, @"Progress must start in 0.0");
    STAssertTrue(_oneFound, @"Progress must end in 1.0");

    STAssertTrue(_completionExecuted, nil);
}

- (void)testCannotTrackProgress {
    
    EBJSONRequest *jsonRequest = [EBJSONRequest requestWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=textfromxcode"]];
    
    jsonRequest.delegate = self;
        
    jsonRequest.completionBlock = ^(id data) {
        _completionExecuted = YES;
        dispatch_semaphore_signal(_semaphore);
    };
    
    [jsonRequest start];
    
    while (dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
    }
    
    STAssertFalse(_canTrackProgress, @"The twitter request should not respond with content size, so it shouldn't be possible to track progress");
    STAssertFalse(_zeroFound, @"Zero should not be received");
    STAssertFalse(_oneFound, @"One should not be received");
    STAssertTrue(_completionExecuted, nil);
}


#pragma mark - Delegate


- (void)request:(EBRequest *)request progressChanged:(float)progress {

    // Record that a 0.0 is received
    if (progress == 0.0) {
        if (_zeroFound) {
            STFail(@"Zero can only be sent once");
        }
        
        _zeroFound = YES;
    }
    
    // Record that a 1.0 is received
    else if (progress == 1.0) {
        if (_oneFound) {
            STFail(@"One can only be sent once");
        }
        _oneFound = YES;
    }
    
    // Check that nothing outside [0.0 and 1.0 is received]
    else if (progress < 0.0 || progress > 1.0) {
        STFail(@"Wrong progress received: %f", progress);
    }
}

- (void)requestCannotReceiveProgressUpdates:(EBRequest *)request {
    _canTrackProgress = NO;
}

@end


