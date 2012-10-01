//
//  EBJSONRequestTests.m
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONRequestTests.h"
#import "EBLibrary.h"
#import "MockPerson.h"

static const NSTimeInterval defaultTimeout = 10;

@implementation EBJSONRequestTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRegularJSON {
    __block BOOL completionExecuted = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURL * url = [[NSBundle bundleForClass:[self class]] URLForResource:@"JSONTest2" withExtension:@"txt"];
    
    EBJSONRequest *request = [EBJSONRequest requestWithURL:url];
    
    request.completionBlock = ^(id data){
        dispatch_semaphore_signal(semaphore);
        
        completionExecuted = YES;
        
        STAssertTrue([data isKindOfClass:[NSDictionary class]], nil);
        
        NSDictionary *dict = (NSDictionary *)data;
        STAssertTrue([dict.allKeys containsObject:@"name"], nil);
        STAssertTrue([dict.allKeys containsObject:@"employed"], nil);
        STAssertTrue([[dict objectForKey:@"age"] isEqual:@32], nil);
        
        STAssertTrue(isDictionary([dict objectForKey:@"address"]), nil);
        STAssertTrue(isArray([dict objectForKey:@"children"]), nil);

    };
    
    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);

        STFail(@"Should not be executed");
    };
    
    [request start];
    
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(completionExecuted, nil);
    
    dispatch_release(semaphore);
    
}


- (void)testMappedJSON {
    __block BOOL completionExecuted = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURL * url = [[NSBundle bundleForClass:[self class]] URLForResource:@"JSONTest2" withExtension:@"txt"];
    
    EBJSONRequest *request = [EBJSONRequest requestWithURL:url];
    
    request.completionBlock = ^(id data){
        dispatch_semaphore_signal(semaphore);
        
        completionExecuted = YES;
        
        STAssertTrue([data isKindOfClass:[MockPerson class]], nil);
        MockPerson *person = data;
        
        STAssertTrue([person.name isEqualToString:@"john smith"], @"Error mapping name");
        STAssertTrue([person.age isEqualToNumber:@32], @"Error mapping age");
        STAssertTrue([person.employed boolValue] == YES, @"Error mapping booleans");
        STAssertNotNil(person.address, @"Error mapping object");
        STAssertFalse(isDictionary(person.address), @"Address is a dictionary, should be an object");
        STAssertTrue([[person.address class] isSubclassOfClass:[MockAddress class]], @"Address should be a MockAddress object");
        STAssertNotNil(person.children, @"Error mapping array");
        STAssertTrue(isArray(person.children), @"Children is not an array");
        STAssertTrue([person.children count] == 3, @"Invalid number of children");
        STAssertTrue([[person.children objectAtIndex:0] isKindOfClass:[MockPerson class]], @"Children is not a MockPerson class");
        
        MockPerson *firstChild = [person.children objectAtIndex:0];
        
        STAssertFalse(isDictionary(firstChild.address), @"Address is a dictionary, should be an object");
        STAssertTrue([[firstChild.address class] isSubclassOfClass:[MockAddress class]], @"Address should be a MockAddress object");
        
        MockPerson *lastChild = [person.children objectAtIndex:2];
        STAssertTrue([lastChild.name isEqualToString:@"james"], @"Invalid children");
        STAssertTrue([lastChild.age isEqualToNumber:@3], nil);
        STAssertTrue([lastChild.children count] == 1, @"Invalid number of children");
        
        MockPerson *grandson = [lastChild.children objectAtIndex:0];
        STAssertTrue([grandson.name isEqualToString:@"supersmall"], @"Invalid children");
        STAssertTrue([grandson.age isEqualToNumber:@1], nil);
        STAssertTrue([grandson.children count] == 1, @"Invalid number of children");
        
        MockPerson *grandgrandson = [grandson.children objectAtIndex:0];
        STAssertTrue([grandgrandson.name isEqualToString:@"supersupersmall"], @"Invalid children");
        STAssertTrue([grandgrandson.age isEqualToNumber:@-1], nil);
        STAssertTrue([grandgrandson.children count] == 0, @"Invalid number of children");

                
    };
    
    request.errorBlock = ^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
        
        STFail(@"Should not be executed");
    };
    
    request.classesToMap = @[[MockPerson class], [MockAddress class]];
    
    [request start];
    
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:defaultTimeout]];
    }
    
    STAssertTrue(completionExecuted, nil);
    
    dispatch_release(semaphore);

}



@end
