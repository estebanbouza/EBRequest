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

    NSDictionary *personDict = @{@"name" : @"John", @"age" : @42};
    
    id person = [mapper objectFromDict:personDict];

}



@end
