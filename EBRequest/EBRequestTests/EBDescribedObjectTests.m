//
//  EBDescribedObjectTests.m
//  EBRequest
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBDescribedObjectTests.h"
#import "EBDescribedObject.h"

#pragma mark - Class Described Person

@interface DescribedPerson : EBDescribedObject

@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSNumber          *age;
@property (nonatomic, retain) DescribedPerson   *partner;

@end

@implementation DescribedPerson

- (void)dealloc {
    [_name release];
    [_age release];
    
    [super dealloc];
}

@end

#pragma mark - Tests

@implementation EBDescribedObjectTests

- (void)testRegularDescribedObject {
    DescribedPerson *person = [DescribedPerson new];
    
    person.name = @"Mary";
    person.age = @42;
    
    STAssertTrue([[person description] isEqualToString:@"age: {42}, name: {Mary}, partner: {(null)}, "], [NSString stringWithFormat:@"Description error: %@", person]);

}

- (void)testDeepObject {
    DescribedPerson *mary = [DescribedPerson new];
    DescribedPerson *john = [DescribedPerson new];

    mary.name = @"Mary";
    john.name = @"John";

    mary.partner = john;

    STAssertTrue([[mary description] isEqualToString:@"age: {(null)}, name: {Mary}, partner: {age: {(null)}, name: {John}, partner: {(null)}, }, "], [NSString stringWithFormat:@"Description error: %@", mary]);

}

// Loops are not yet supported. This test will crash.
- (void)testLoop {
//    DescribedPerson *mary = [DescribedPerson new];
//    DescribedPerson *john = [DescribedPerson new];
//
//    mary.name = @"Mary";
//    john.name = @"John";
//    
//    mary.partner = john;
//    john.partner = mary;
//    
//    DLog(@"%@", mary);
}

@end
