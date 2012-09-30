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


- (void)testRegularMapping {
    EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClass:[MockPerson class]];

    NSDictionary *personDict = @{@"name" : @"John", @"age" : @42, @"birthDate" : @"542721600"};
    
    MockPerson *person = [mapper objectFromDict:personDict];

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



@end
