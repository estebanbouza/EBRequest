//
//  EBArgumentMapper.m
//  EBRequest
//
//  Created by Esteban on 10/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBPropertyMapper.h"

@implementation EBPropertyMapper

- (void)dealloc {
    [_theClass release];
    [_argumentMapper release];
    
    [super dealloc];
}

@end
