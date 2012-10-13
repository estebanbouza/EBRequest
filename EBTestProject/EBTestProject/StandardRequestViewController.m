//
//  StandardRequestViewController.m
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "StandardRequestViewController.h"

static NSString *testURLString = @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=textfromxcode&include_rts=0";


@interface StandardRequestViewController () {
    EBDataRequest *_request;
}

@end

@implementation StandardRequestViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    self.lblURL.text = testURLString;
    
    _request = [EBDataRequest requestWithURL:[NSURL URLWithString:testURLString]];
    
    _request.completionBlock = ^(id responseData) {
        self.txtResult.text = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [self.activityIndicator stopAnimating];
    };
    
    [self.activityIndicator startAnimating];
    [_request start];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
