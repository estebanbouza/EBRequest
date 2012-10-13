//
//  StandardRequestViewController.m
//  EBTestProject
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "ResultViewController.h"



@interface ResultViewController () {
}

@end

@implementation ResultViewController

- (id)init {
    return [self initWithNibName:@"ResultViewController" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}



- (void)viewDidUnload {
    [self setLblURL:nil];
    [self setTxtResult:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

@end
