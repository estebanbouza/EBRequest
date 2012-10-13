//
//  MappedJSONViewController.m
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MappedJSONViewController.h"

#import "Response.h"

@interface MappedJSONViewController () {
    EBJSONRequest *_request;
}

@end

@implementation MappedJSONViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];

    // Use Google news API to search news related with pizza. 
    NSURL *pizzaURL = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=pizza"];
    
    self.lblURL.text = pizzaURL.description;

    // Create a request object
    _request = [EBJSONRequest requestWithURL:pizzaURL];
    
    // Tell the request which objects can be used for mapping
    _request.JSONObjectMapper = [EBJSONObjectMapper mapperWithClasses:
                                 @[[ResponseData class],
                                 [Response class],
                                 [Entry class]]];
    
    // What to do when the request is finished
    _request.completionBlock = ^(id response) {
        NSString *text = [NSString string];
        
        ResponseData *responseData = ((Response *)response).responseData;

        text = [text stringByAppendingFormat:@"The query: %@\n", responseData.query];
        text = [text stringByAppendingFormat:@"And the status: %@\n\n\n", ((Response *)response).responseStatus];
        
        for (Entry *entry in responseData.entries) {
            text = [text stringByAppendingFormat:@"Title: %@\n", entry.title];
            text = [text stringByAppendingFormat:@"Content: %@", entry.contentSnippet];;
            text = [text stringByAppendingString:@"\n\n"];
        }
        
        self.txtResult.text = text;
        
        [self.activityIndicator stopAnimating];
    };
    
    // Just in case
    _request.errorBlock = ^(NSError *error) {
        self.txtResult.text = [NSString stringWithFormat:@"Something bad happened :-S %@", error];
        [self.activityIndicator stopAnimating];
    };

    // and start!
    [_request start];

}


@end
