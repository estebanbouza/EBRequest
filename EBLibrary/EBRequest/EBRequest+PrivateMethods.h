//
//  EBRequest+PrivateMethods.h
//  EBLibrary
//
//  Created by Esteban on 22/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequest.h"

@interface EBRequest (PrivateMethods)

- (void)notifyCannotTrackProgress;
- (void)notifyProgressChange:(long long)progress expected:(long long)expected;

@end
