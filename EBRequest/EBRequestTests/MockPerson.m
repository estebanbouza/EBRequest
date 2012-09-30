//
//  MockPerson.m
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MockPerson.h"

@implementation MockPerson

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, Age: %d", self.name, self.age];
}

@end
