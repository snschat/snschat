//
//  SignupVC.h
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListPopoverVC.h"
#import "DatePopoverVC.h"

#import "User.h"

@interface SignupVC : UIViewController <ListPopoverDelegate, DatePopoverDelegate>

@property (strong, nonatomic) IBOutlet UIView *signupView;
@property (strong, nonatomic) IBOutlet UILabel *signupMessageLabel;
@property (strong, nonatomic) IBOutlet UIView *signupInputView;
@property (strong, nonatomic) IBOutlet UIView *interrupterView;

@property (strong, nonatomic) IBOutlet UITextField *signupUsername;
@property (strong, nonatomic) IBOutlet UITextField *signupEmail;
@property (strong, nonatomic) IBOutlet UITextField *signupPassword;
@property (strong, nonatomic) IBOutlet UITextField *signupConfirm;
@property (strong, nonatomic) IBOutlet UITextField *signupLocation;
@property (strong, nonatomic) IBOutlet UITextField *signupBirthday;
@property (strong, nonatomic) IBOutlet UITextField *signupGender;

@property (strong, nonatomic) IBOutlet UIImageView *imgStar1;
@property (strong, nonatomic) IBOutlet UIImageView *imgStar2;
@property (strong, nonatomic) IBOutlet UIImageView *imgStar3;
@property (strong, nonatomic) IBOutlet UIImageView *imgStar4;
@property (strong, nonatomic) IBOutlet UIImageView *imgStar5;

@property (strong, nonatomic) IBOutlet UIButton *singupButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *signupAgreeChecker;
@property (strong, nonatomic) IBOutlet UILabel *pageDescriptionLabel;

@property (strong, nonatomic) User* prefilleddUser;

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
