//
//  BrowserHomeVC.h
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserHomeVC : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *chatbar;
@property (strong, nonatomic) IBOutlet UIButton *buttonChatSlider;

@property (strong, nonatomic) IBOutlet UIView *layTabbar;

@property (strong, nonatomic) IBOutlet UIView *mainview;

@end
