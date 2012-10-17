//
//  MultipleImageViewController.m
//  EBExampleProject
//
//  Created by Esteban on 17/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "MultipleImageViewController.h"

#import "ImageCell.h"

static const NSInteger kNumberOfRows = 50;

static const NSInteger kQuerySearchPages = 5;

@interface MultipleImageViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_imageEntries;
    NSMutableArray *_queryURLs;
}

@end

@implementation MultipleImageViewController

- (id)init {
    if (self = [super init]) {
        _imageEntries = [NSMutableArray array];
        
        _queryURLs = [NSMutableArray array];
        for (int i = 0; i < kQuerySearchPages; i++) {
            [_queryURLs addObject:[NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=pizza&rsz=8&start=%d", i]]];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self queryImageURLs];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @":-)";
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    [cell.imageRequest stop];
    cell.imageView.image = [self placeholderImage];
    
    ImageEntry *entry = _imageEntries[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row, entry.titleNoFormatting];
    
    cell.imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:entry.url]];
    cell.imageRequest.completionBlock = ^ (id data) {
        DLog(@"Painting...");
        
        UIImage *image = (UIImage *)data;
        
        cell.imageView.image = image;
        
    };
    
    [cell.imageRequest start];
    
    return cell;
}



- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_imageEntries count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - query for image URLs

- (void)queryImageURLs {
    for (NSURL *queryURL in _queryURLs) {
        EBJSONRequest *jsonRequest = [EBJSONRequest requestWithURL:queryURL];
        
        EBJSONObjectMapper *mapper = [EBJSONObjectMapper mapperWithClasses:
                                      @[[ImageEntry class],
                                      [ImageResponse class],
                                      [ImageResponseData class]]];
        
        jsonRequest.JSONObjectMapper = mapper;
        
        jsonRequest.completionBlock = ^ (id data){
            if (![data isKindOfClass:[ImageResponse class]]) {
                DLog(@"Invalid class. Blame esteban.bouza {at] gmail dot com: %@", [data class]);
                return;
            }
            
            ImageResponse *response = (ImageResponse *)data;
            
            [_imageEntries addObjectsFromArray:response.responseData.results];
            
            [_tableView reloadData];
        };
        
        [jsonRequest start];
    }
}


- (UIImage *)placeholderImage {
    return [UIImage imageNamed:@"placeholder"];
}

@end
