//
//  MultipleImageViewController.m
//  EBExampleProject
//
//  Created by Esteban on 17/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MultipleImageViewController.h"

#import "ImageCell.h"

static const NSInteger  kQuerySearchPages = 5;
const static NSString   *kQueryString = @"Lettuce";

const static CGFloat    kRowHeight = 80.0f;

@interface MultipleImageViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_imageEntries;
    NSMutableArray *_queryURLs;
}

@end

@implementation MultipleImageViewController

#pragma mark - Lifecycle

- (id)init {
    if (self = [super init]) {
        _imageEntries = [NSMutableArray array];
        
        _queryURLs = [NSMutableArray array];
        for (int i = 0; i < kQuerySearchPages; i++) {
            [_queryURLs addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&rsz=8&start=%d", kQueryString, i]]];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0,
                                 CGRectGetHeight(self.navigationController.navigationBar.frame),
                                 CGRectGetWidth(self.view.frame),
                                 CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame));
    
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self queryImageURLs];
}

#pragma mark - Table view
#pragma mark Datasource

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @":-)";
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    // Stop the request if there was one running before
    [cell.imageRequest stop];
    
    // Clear the current image just in case.
    cell.imageView.image = [self placeholderImage];
    
    // Get the current entry
    ImageEntry *entry = _imageEntries[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row, entry.titleNoFormatting];
    
    // Assign a new Image Request related to the Cell
    cell.imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:entry.url]];

    // Paint the cell when it's finished
    cell.imageRequest.completionBlock = ^ (id data) {
        UIImage *image = (UIImage *)data;
        
        cell.imageView.image = image;
    };
    
    [cell.imageRequest start];
    
    return cell;
}



- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_imageEntries count];
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Queries

// This method extracts the image objects from Google Images API results.
- (void)queryImageURLs {
    for (NSURL *queryURL in _queryURLs) {
        EBJSONRequest *jsonRequest = [EBJSONRequest requestWithURL:queryURL];
        
        EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:
                                      @[[ImageEntry class],
                                      [ImageResponse class],
                                      [ImageResponseData class]]];
        
        jsonRequest.JSONObjectMapper = mapper;
        
        jsonRequest.completionBlock = ^ (id data){
            // Data is already mapped to custom classes.
            ImageResponse *response = (ImageResponse *)data;
            
            [_imageEntries addObjectsFromArray:response.responseData.results];
            
            [_tableView reloadData];
        };
        
        [jsonRequest start];
    }
}

#pragma mark - Generic

- (UIImage *)placeholderImage {
    return [UIImage imageNamed:@"placeholder"];
}

@end
