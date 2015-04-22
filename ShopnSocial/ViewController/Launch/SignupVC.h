//
//  SignupVC.h
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *signupView;
@property (strong, nonatomic) IBOutlet UILabel *signupMessageLabel;
@property (strong, nonatomic) IBOutlet UIView *signupInputView;

@property (strong, nonatomic) IBOutlet UITextField *signupUsername;
@property (strong, nonatomic) IBOutlet UITextField *signupEmail;
@property (strong, nonatomic) IBOutlet UITextField *signupPassword;
@property (strong, nonatomic) IBOutlet UITextField *signupConfirm;
@property (strong, nonatomic) IBOutlet UITextField *signupLocation;
@property (strong, nonatomic) IBOutlet UITextField *signupBirthday;
@property (strong, nonatomic) IBOutlet UITextField *signupGender;

@property (strong, nonatomic) IBOutlet UIButton *signupAgreeChecker;

- (IBAction)onCancel;
- (IBAction)onSignup;
- (IBAction)onAgreeChecker;

- (IBAction)onTermsAndConditions;
- (IBAction)onPrivacyPolicy;

- (void) hideMessage;

- (void) showNoInternetMessage;
- (void) showMandatoryMessage;
- (void) showDuplicatedUsernameMessage;
- (void) showInvalidPasswordMessage;
- (void) showUnmatchedPasswordMessage;
- (void) showInvalidEmailMessage;
- (void) showDuplicatedEmailMessage;

@end
