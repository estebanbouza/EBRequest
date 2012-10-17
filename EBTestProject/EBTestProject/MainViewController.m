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
#import "MultipleImageViewController.h"

typedef enum {
    kRowStandardRequest,
    kRowMappedJSONRequest,
    kRowImageRequest,
    kRowMultipleImageRequest,
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
    
    self.view.frame = CGRectMake(0,
                                 CGRectGetHeight(self.navigationController.navigationBar.frame),
                                 CGRectGetWidth(self.view.frame),
                                 CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame));
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
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
            
            case kRowMultipleImageRequest:
            cell.textLabel.text = @"Multiple Image Request";
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
            
        case kRowMultipleImageRequest: {
            MultipleImageViewController *multipleVC = [MultipleImageViewController new];
            [self.navigationController pushViewController:multipleVC animated:YES];
        }
            
        default:
            break;
    }
    
}



@end
