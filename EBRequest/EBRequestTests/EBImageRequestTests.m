//
//  EBImageRequestTests.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBImageRequestTests.h"
#import <UIKit/UIKit.h>

static const NSTimeInterval defaultTimeout = 10;

@implementation EBImageRequestTests

- (void)testDownloadImage {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL completionExecuted = NO;
    
    EBImageRequest *imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/images/srpr/logo3w.png"]];
    
    imageRequest.completionBlock = ^(id img) {
        UIImage *image = (UIImage *)img;
        DLog(@"Image downloaded: %@", image);
    };
    
    imageRequest.errorBlock = ^(NSError *error) {
        STFail(@"Error downloading image: %@", error);
    };
    
    [imageRequest start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(completionExecuted, nil);
    
    dispatch_release(semaphore);

}

@end
