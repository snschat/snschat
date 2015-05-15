//
//  SplashVC.h
//  ShopnSocial
//
//  Created by rock on 4/21/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Global.h"

@interface SplashVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIImageView *logoRedImageView;
@property (strong, nonatomic) IBOutlet UILabel *noInternetLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

@end
