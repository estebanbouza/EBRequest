//
//  MultipleImageViewController.m
//  EBExampleProject
//
//  Created by Esteban on 17/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MultipleImageViewController.h"

static const NSInteger kNumberOfRows = 50;

@interface MultipleImageViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
}

@end

@implementation MultipleImageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @":-)";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
