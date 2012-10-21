//
//  EBRequest+Notifications.m
//  EBLibrary
//
//  Created by Esteban on 21/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequest+Notifications.h"

@implementation EBRequest (Notifications)

#pragma mark - Internal

- (void)notifyCannotTrackProgress {
    if ([self.delegate respondsToSelector:@selector(requestCannotReceiveProgressUpdates:)]) {
        [self.delegate requestCannotReceiveProgressUpdates:self];
    }
}

- (void)notifyProgressChange:(long long)progress expected:(long long)expected {
    if ([self.delegate respondsToSelector:@selector(request:progressChanged:)] &&
        expected > 0.0f) {
        float normalizedProgress = ((float) progress / (float) expected);
        
        [self.delegate request:self progressChanged:normalizedProgress];
    }
}

@end
