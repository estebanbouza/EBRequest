//
//  EBRequestTests.m
//  EBRequestTests
//
//  Created by Esteban on 29/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequestTests.h"
#import "EBLibrary.h"

static NSString *testURLString = @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=textfromxcode&include_rts=0";

static const NSTimeInterval defaultTimeout = 10;

@implementation EBRequestTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testRegularAsyncConnection {
    
   dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    EBRequest *request = [[EBRequest alloc] initWithURL:[NSURL URLWithString:testURLString]];
    
    request.completionBlock = ^(NSData *responseData) {
        dispatch_semaphore_signal(semaphore);

        STAssertNotNil(responseData, @"Response data should be initialized");

    };

    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);

        STFail(@"Request failed");
    };
    
    BOOL status = [request start];
    
    STAssertTrue(status, @"Request could not be started");
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    dispatch_release(semaphore);
    
    [request release];
}

- (void)testRegularAutoreleasedAsyncConnection {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    EBRequest *request = [EBRequest requestWithURL:[NSURL URLWithString:testURLString]];
    
    request.completionBlock = ^(NSData *responseData) {
        dispatch_semaphore_signal(semaphore);
        
        STAssertNotNil(responseData, @"Response data should be initialized");
        
    };
    
    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);

        STFail(@"Request failed");
    };
    
    BOOL status = [request start];
    
    STAssertTrue(status, @"Request could not be started");
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    dispatch_release(semaphore);
    
}

- (void)testFailedConnection {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    EBRequest *request = [EBRequest requestWithURL:[NSURL URLWithString:@"http://fals3-d0m4in.com"]];
    
    request.completionBlock = ^(NSData *responseData) {
        dispatch_semaphore_signal(semaphore);

        STFail(@"Completion block should not be executed");
    };
    
    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);

        STAssertNotNil(error, @"An error is supposed to happen");
        STAssertEquals(error.code, -1003, @"The server should not be found");
    };
    
    [request start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    dispatch_release(semaphore);
    
}

- (void)testStopRequest {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    EBRequest *request = [[EBRequest alloc] initWithURL:[NSURL URLWithString:testURLString]];
    
    request.completionBlock = ^(NSData *responseData) {
        dispatch_semaphore_signal(semaphore);
        STFail(@"Request should never be completed");
    };
    
    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
        STFail(@"Request should never be completed");
    };
    
    [request start];
    [request stop];
    
    dispatch_semaphore_signal(semaphore);
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    dispatch_release(semaphore);
    
    [request release];
}



@end
