//
//  EBJSONRequest.h
//  EBRequest
//
//  Created by Esteban on 01/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "EBRequest.h"
#import "EBJSONObjectMapper.h"

/// EBJSONRequest returns JSON or Custom objects in the completion block. For more information see property JSONObjectMapper
@interface EBJSONRequest : EBRequest

/// Optional argument. If the parameter is not nil, the result of the mapping will be custom classes instead of NSDictionary and NSArrays.
@property (nonatomic, retain) EBJSONObjectMapper *JSONObjectMapper;

@end
