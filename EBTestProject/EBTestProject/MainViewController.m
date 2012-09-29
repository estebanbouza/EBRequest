//
//  MainViewController.m
//  EBTestProject
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MainViewController.h"



typedef enum {
    kRowStandardRequest,
    kNumberOfRows
} t_rows;

static NSString *tableReuseID = @":)";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.tableView.autoresizingMask = ~UIViewAutoresizingNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = @"EBLibrary";
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableReuseID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableReuseID];
    }
    
    switch (indexPath.row) {
        case kRowStandardRequest:
            cell.textLabel.text = @"Standard request";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
