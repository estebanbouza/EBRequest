//
//  MainViewController.m
//  EBTestProject
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MainViewController.h"

#import "ResultViewController.h"
#import "MappedJSONViewController.h"
#import "StandardRequestViewController.h"
#import "ImageViewController.h"

typedef enum {
    kRowStandardRequest,
    kRowMappedJSONRequest,
    kRowImageRequest,
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
            break;
            
        case kRowMappedJSONRequest:
            cell.textLabel.text = @"Mapped JSON to NSObjects";
            break;
            
        case kRowImageRequest:
            cell.textLabel.text = @"Image request";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case kRowStandardRequest: {
            StandardRequestViewController *reqVC = [StandardRequestViewController new];
            [self.navigationController pushViewController:reqVC animated:YES];
            
            break;
        }
            
        case kRowMappedJSONRequest: {
            MappedJSONViewController *mappedVC = [MappedJSONViewController new];
            [self.navigationController pushViewController:mappedVC animated:YES];
            
            break;
        }
            
        case kRowImageRequest: {
            ImageViewController *imgVC = [ImageViewController new];
            [self.navigationController pushViewController:imgVC animated:YES];
            
            break;
        }
            
        default:
            break;
    }
    
}



@end
