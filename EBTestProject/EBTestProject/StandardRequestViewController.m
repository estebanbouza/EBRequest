//
//  StandardRequestViewController.m
//  EBTestProject
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "StandardRequestViewController.h"

static NSString *testURLString = @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=textfromxcode&include_rts=0";


@interface StandardRequestViewController () {
    EBRequest *request;
}

@end

@implementation StandardRequestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lblURL.text = testURLString;
    
    request = [EBRequest requestWithURL:[NSURL URLWithString:testURLString]];
    
    request.completionBlock = ^(id responseData) {
        self.txtResult.text = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [self.activityIndicator stopAnimating];
    };
    
    [self.activityIndicator startAnimating];
    [request start];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblURL:nil];
    [self setTxtResult:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
