//
//  EBImageRequestTests.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBImageRequestTests.h"
#import <UIKit/UIKit.h>
#import "MockPerson.h"

static const NSTimeInterval defaultTimeout = 10;

@implementation EBImageRequestTests

- (void)testDownloadImage {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL completionExecuted = NO;
    
    EBImageRequest *imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/images/srpr/logo3w.png"]];
    
    imageRequest.completionBlock = ^(id img) {
        dispatch_semaphore_signal(semaphore);
        completionExecuted = YES;

        STAssertTrue([img isKindOfClass:[UIImage class]], nil);
    };
    
    imageRequest.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);

        STFail(@"Error downloading image: %@", error);
    };
    
    [imageRequest start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(completionExecuted, nil);
    
    dispatch_release(semaphore);

}


- (void)testDownloadInvalidURL {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL errorExecuted = NO;
    
    EBImageRequest *imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"http://localhost:666/void.jpg"]];
    
    imageRequest.completionBlock = ^(id img) {
        dispatch_semaphore_signal(semaphore);
        
        STFail(@"This request should fail");
    };
    
    imageRequest.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
        
        errorExecuted = YES;
        STAssertNotNil(error, @"An error should be raised");
    };
    
    [imageRequest start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(errorExecuted, nil);
    
    dispatch_release(semaphore);
}


- (void)testDownloadWrongImage {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL errorExecuted = NO;
    
    EBImageRequest *imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"http://dl.dropbox.com/u/425260/EBRequestInvalidImage.png"]];
    
    imageRequest.completionBlock = ^(id img) {
        dispatch_semaphore_signal(semaphore);
        
        STFail(@"This request should fail");
    };
    
    imageRequest.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
        
        errorExecuted = YES;
        STAssertNotNil(error, @"An error should be raised");
        STAssertTrue(error.code == -1, @"Invalid error code: %@", error);
    };
    
    [imageRequest start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(errorExecuted, nil);
    
    dispatch_release(semaphore);
}


@end
