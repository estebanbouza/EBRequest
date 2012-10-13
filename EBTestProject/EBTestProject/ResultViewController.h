//
//  StandardRequestViewController.h
//  EBTestProject
//
//  Created by Esteban on 30/09/12.
//  Copyright (c) 2012 Esteban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblURL;
@property (weak, nonatomic) IBOutlet UITextView *txtResult;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
