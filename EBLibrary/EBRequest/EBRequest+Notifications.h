//
//  EBRequest+Notifications.h
//  EBLibrary
//
//  Created by Esteban on 21/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <EBLibrary/EBLibrary.h>

@interface EBRequest (Notifications)

- (void)notifyCannotTrackProgress;
- (void)notifyProgressChange:(long long)progress expected:(long long)expected;
    
@end
