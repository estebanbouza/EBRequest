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
    EBDataRequest *request;
}

@end

@implementation StandardRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.lblURL.text = testURLString;
    
    request = [EBDataRequest requestWithURL:[NSURL URLWithString:testURLString]];
    
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

@end
