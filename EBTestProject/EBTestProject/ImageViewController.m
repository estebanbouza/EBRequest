//
//  ImageViewController.m
//  EBTestProject
//
//  Created by Esteban on 13/10/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () {
    EBImageRequest *_imageRequest;
}

@property (nonatomic, strong) UIImageView *imageView;

@end



@implementation ImageViewController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    [self.activityIndicator startAnimating];

    _imageRequest = [EBImageRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com/images/srpr/logo3w.png"]];
    
    _imageRequest.completionBlock = ^(id img) {
        UIImage *image = (UIImage *)img;
      
        self.imageView.image = image;
        [self.activityIndicator stopAnimating];
    };
    
    _imageRequest.errorBlock = ^(NSError *error) {
        self.txtResult.text = error.description;
        
        [self.activityIndicator stopAnimating];
    };
    
    [_imageRequest start];
}



@end
