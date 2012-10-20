//
//  MemoryUsageViewController.m
//  EBExampleProject
//
//  Created by Esteban on 20/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MemoryUsageViewController.h"

static const NSInteger kRepeat = 10000;

@interface MemoryUsageViewController () {
    NSOperationQueue *_queue;
}

@end

@implementation MemoryUsageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _queue = [NSOperationQueue new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Start Processing" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(500, 00, 200, 40);
    [self.view addSubview:button];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton setTitle:@"Stop Processing" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    stopButton.frame = CGRectMake(500, 40, 200, 40);
    [self.view addSubview:stopButton];
    
    
}

- (void)buttonPressed:(id)sender {
    [_queue cancelAllOperations];
    
    EBDataRequest *dataRequest = nil;
    
    
    for (int i = 0; i < kRepeat; i++) {
        dataRequest = [[EBDataRequest alloc] initWithURL:nil];
        [dataRequest release];
        
    }
    
}


- (void)buttonStopPressed:(id)sender {
    [_queue cancelAllOperations];
}

@end
