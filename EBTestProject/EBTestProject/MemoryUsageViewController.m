//
//  MemoryUsageViewController.m
//  EBExampleProject
//
//  Created by Esteban on 20/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MemoryUsageViewController.h"

static const NSInteger kRepeat = 1000;

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
    button.frame = CGRectMake(500, 30, 200, 40);
    [self.view addSubview:button];
    
    self.txtResult.text = @"The only purpose of this view is to test the memory performance of the library.\nNothing else useful can be found here.";

}

- (void)buttonPressed:(id)sender {
    [_queue cancelAllOperations];
    
    EBDataRequest *dataRequest = nil;
    EBImageRequest *imageRequest = nil;
    EBJSONRequest *jsonRequest = nil;
    EBJSONObjectMapper *jsonMapper = nil;
    
    for (int i = 0; i < kRepeat; i++) {
        dataRequest = [[EBDataRequest alloc] initWithURL:nil];
        [dataRequest start];
        [dataRequest stop];
        [dataRequest release];
        
        imageRequest = [[EBImageRequest alloc] initWithURL:nil];
        [imageRequest start];
        [imageRequest stop];
        [imageRequest release];
        
        jsonRequest = [[EBJSONRequest alloc] initWithURL:nil];
        [jsonRequest start];
        [jsonRequest stop];
        [jsonRequest release];
        
        jsonMapper = [[EBJSONObjectMapper alloc] initWithClass:[self class]];
        [jsonMapper objectFromJSON:nil];
        [jsonMapper release];
    }
    
}

@end
