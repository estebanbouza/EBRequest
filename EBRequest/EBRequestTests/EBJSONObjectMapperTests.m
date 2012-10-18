//
//  EBJSONObjectMapperTests.m
//  EBRequest
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBJSONObjectMapperTests.h"
#import "EBLibrary.h"

#import "MockPerson.h"

@implementation EBJSONObjectMapperTests


- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}



#pragma mark - JSON Validation


- (BOOL)validateJSON2:(MockPerson *)person {
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
    
    return YES;
}


- (BOOL)validateJSON1:(MockPerson *)person {
    STAssertTrue([person.name isEqualToString:@"john smith"], @"Error mapping name");
    STAssertTrue([person.age isEqualToNumber:@32], @"Error mapping age");
    STAssertTrue([person.employed boolValue] == YES, @"Error mapping booleans");
    STAssertNotNil(person.address, @"Error mapping object");
    
    STAssertFalse(isDictionary(person.address), @"Address is a dictionary, should be an object");
    STAssertTrue([[person.address class] isSubclassOfClass:[MockAddress class]], @"Address should be a MockAddress object");
    STAssertTrue([person.address.street isEqualToString:@"701 first ave."], nil);
    STAssertTrue([person.address.city isEqualToString:@"sunnyvale, ca 95125"], nil);
    STAssertTrue([person.address.country isEqualToString:@"united states"], nil);
    
    STAssertNotNil(person.children, @"Error mapping array");
    STAssertTrue(isArray(person.children), @"Children is not an array");
    STAssertTrue([person.children count] == 3, @"Invalid number of children");
    STAssertTrue([[person.children objectAtIndex:0] isKindOfClass:[MockPerson class]], @"Children is not a MockPerson class");
    for (MockPerson *child in person.children) {
        STAssertTrue([child isKindOfClass:[MockPerson class]], @"Children is not a MockPerson class");
    }
    
    STAssertTrue([[[person.children objectAtIndex:0] name] isEqualToString:@"richard"], @"Error mapping children");
    STAssertTrue([[[person.children objectAtIndex:1] name] isEqualToString:@"susan"], @"Error mapping children");
    STAssertTrue([[[person.children objectAtIndex:2] name] isEqualToString:@"james"], @"Error mapping children");
    
    STAssertTrue([[[person.children objectAtIndex:0] age] isEqualToNumber:@7], @"Error mapping children");
    STAssertTrue([[[person.children objectAtIndex:1] age] isEqualToNumber:@4], @"Error mapping children");
    STAssertTrue([[[person.children objectAtIndex:2] age] isEqualToNumber:@3], @"Error mapping children");
    
    return YES;
    
}


- (BOOL)validateJSON3:(NSArray *)result {
    STAssertTrue(isArray(result), @"Result is not array");
    STAssertTrue(result.count == 4, @"Incorrect array count");
    
    STAssertTrue([[result objectAtIndex:0] isKindOfClass:[MockPerson class]], @"Error mapping classes");
    STAssertTrue([[result objectAtIndex:1] isKindOfClass:[MockAddress class]], @"Error mapping classes");
    STAssertTrue([[result objectAtIndex:2] isKindOfClass:[MockPerson class]], @"Error mapping classes");
    STAssertTrue([[result objectAtIndex:3] isKindOfClass:[MockPerson class]], @"Error mapping classes");
    
    MockPerson *first = [result objectAtIndex:0];
    STAssertTrue([first.name isEqualToString:@"john smith"], nil);
    STAssertTrue([first.address.city isEqualToString:@"sunnyvale, ca 95125"], nil);
    
    MockAddress *second = [result objectAtIndex:1];
    STAssertTrue([second.street isEqualToString:@"701 first ave."], nil);
    
    MockPerson *third = [result objectAtIndex:2];
    STAssertTrue([third.name isEqualToString:@"manolo"], nil);
    STAssertNil(third.address, nil);
    STAssertNotNil(third.children, nil);
    STAssertTrue(third.children.count == 2, nil);
    STAssertTrue([[[third.children objectAtIndex:0] name] isEqualToString:@"little manolo A"], nil);
    STAssertTrue([[[third.children objectAtIndex:1] name] isEqualToString:@"little manolo B"], nil);
    
    MockPerson *fourth = [result objectAtIndex:3];
    STAssertTrue([fourth.name isEqualToString:@"patty"], nil);
    STAssertNotNil(fourth.address, nil);
    
    return YES;
}

#pragma mark Mapping

- (void)testRegularMapping {
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClass:[MockPerson class]];

    NSDictionary *personDict = @{@"name" : @"John", @"age" : @42, @"birthDate" : @"542721600"};
    
    MockPerson *person = [mapper objectFromJSON:personDict];

    STAssertNotNil(person, @"Object not created");
    
    STAssertEquals(person.name, @"John", @"String mapping not working");
    STAssertTrue([person.age isEqualToNumber:@42], @"Number mapping not working");
    
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:person.birthDate];

    STAssertEquals(components.year, 1987, @"Year mapping not working");
    STAssertEquals(components.month, 3, @"Month mapping not working");
    STAssertEquals(components.day, 14, @"Day mapping not working");
    STAssertEquals(components.hour, 13, @"Hour mapping not working");
    STAssertEquals(components.minute, 0, @"Hour mapping not working");
    STAssertEquals(components.second, 0, @"Second mapping not working");
}

- (void)testSeveralClassMapping {
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];
    
    NSDictionary *personDict = @{@"name" : @"John", @"age" : @42, @"birthDate" : @"542721600"};
    
    MockPerson *person = [mapper objectFromJSON:personDict];
    
    STAssertNotNil(person, @"Object not created");
    
    STAssertEquals(person.name, @"John", @"String mapping not working");
    STAssertTrue([person.age isEqualToNumber:@42], @"Number mapping not working");
}


- (void)testStaticJSONMapping {
    NSError *error;
    
    NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[MockPerson class]] pathForResource:@"JSONTest1" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];
    
    MockPerson *person = [mapper objectFromJSON:json];
    
    STAssertTrue([self validateJSON1:person], nil);
}


- (void)testComplexJSONMapping {
    NSError *error;
    
    NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[MockPerson class]] pathForResource:@"JSONTest2" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];
    
    MockPerson *person = [mapper objectFromJSON:json];

    STAssertTrue([self validateJSON2:person], nil);
}



- (void)testArrayJSONMapping {
    NSError *error;
    
    NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[MockPerson class]] pathForResource:@"JSONTest3" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];
    
    NSArray *result = [mapper objectFromJSON:json];
    
    STAssertTrue([self validateJSON3:result], nil);
}


#pragma mark - Property Mapper tests

- (void)testPropertyMapper {
    NSError *error;

    NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:[MockPerson class]] pathForResource:@"JSONTestPropertyMapper" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];
    
    // Create property mappers for person and address.
    EBPropertyMapper *personMapper = [EBPropertyMapper mapperWithClass:[MockPerson class]
                                                            properties:@{@"name" : @"j_name",
                                                                     @"employed" : @"j_employed",
                                                                      @"address" : @"j_address",
                                                                     @"children" : @"j_children"
                                      }];
    
    EBPropertyMapper *addressMapper = [EBPropertyMapper mapperWithClass:[MockAddress class] properties:@{@"city" : @"j_city", @"country" : @"j_country"}];
    mapper.propertyMappers = @[personMapper, addressMapper];

    // Start mapping the JSON
    MockPerson *person = [mapper objectFromJSON:json];
    
    [self validateJSON1:person];
}

- (void)testRequestPropertyMapper {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BOOL completionExecuted = NO;
    
    NSURL *jsonURL = [[NSBundle bundleForClass:[MockPerson class]] URLForResource:@"JSONTestPropertyMapper" withExtension:@"txt"];
    
    EBJSONRequest *request = [EBJSONRequest requestWithURL:jsonURL];
    
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:@[[MockPerson class], [MockAddress class]]];

    // Create property mappers for person and address.
    EBPropertyMapper *personMapper = [EBPropertyMapper mapperWithClass:[MockPerson class]
                                                            properties:@{@"name" : @"j_name",
                                      @"employed" : @"j_employed",
                                      @"address" : @"j_address",
                                      @"children" : @"j_children"
                                      }];
    
    EBPropertyMapper *addressMapper = [EBPropertyMapper mapperWithClass:[MockAddress class] properties:@{@"city" : @"j_city", @"country" : @"j_country"}];
    mapper.propertyMappers = @[personMapper, addressMapper];
    
    request.JSONObjectMapper = mapper;
    
    request.completionBlock = ^(id data) {
        MockPerson *person = (MockPerson *)data;
        
        [self validateJSON1:person];
        completionExecuted = YES;
        dispatch_semaphore_signal(semaphore);
    };
    
    request.errorBlock = ^(NSError *error) {
        STFail(@"Shouldn't fail %@", error);
        dispatch_semaphore_signal(semaphore);

    };
    
    [request start];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
    }
    
    STAssertTrue(completionExecuted, nil);
    
    dispatch_release(semaphore);
    
}



@end
