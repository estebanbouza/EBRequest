//
//  MockPerson.h
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MockAddress.h"

@interface MockPerson : NSObject

@property (nonatomic, strong)                       NSString    *name;
@property (nonatomic, strong)                       NSNumber    *age;
@property (nonatomic, strong)                       NSDate      *birthDate;
@property (nonatomic, strong, getter = isEmployed)  NSNumber    *employed;
@property (nonatomic, strong)                       MockAddress *address;
@property (nonatomic, strong)                       NSArray     *children;

@end
