//
//  ResetPasswordVC.h
//  ShopnSocial
//
//  Created by rock on 5/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *interuptView;
@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UIView *emailField;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *infoNoInternet;
@property (strong, nonatomic) IBOutlet UIView *infoContactUs;
@property (strong, nonatomic) IBOutlet UILabel *infoResetPassword;

@property (strong, nonatomic) IBOutlet UIView *description1;
@property (strong, nonatomic) IBOutlet UIView *description2;

- (IBAction)onSend;

- (IBAction)onCancel;
@end
