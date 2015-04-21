//
//  LoginVC.h
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController


#pragma mark - login view

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *loginUsername;
@property (strong, nonatomic) IBOutlet UITextField *loginPassword;
@property (strong, nonatomic) IBOutlet UILabel *loginMessageLabel;
@property (strong, nonatomic) IBOutlet UIView *loginInputView;

- (IBAction)onFacebook;
- (IBAction)onTwitter;
- (IBAction)onGooglePlus;
- (IBAction)onRegister;
- (IBAction)onSignin;
- (IBAction)onForgotPassword;

- (void) hideLoginMessage;
- (void) showLoginIncorrectMessage;
- (void) showLoginLockedMessage;

#pragma mark - login view


@end
