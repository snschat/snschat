//
//  SignupVC.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SignupVC.h"
#import "ExUILabel+AutoSize.h"
#import "ExUIView+Border.h"

@interface SignupVC ()
{
    UIColor* redColor;
    
    UIViewController* termsVC;
    UIViewController* privacyVC;
}
@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    redColor = self.signupMessageLabel.textColor;
    
    [self.interrupterView.superview bringSubviewToFront:self.interrupterView];
    self.interrupterView.hidden = YES;

    termsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsVC"];
    privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyVC"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -

- (IBAction)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSignup {

}

- (IBAction)onAgreeChecker {
    self.signupAgreeChecker.selected = !self.signupAgreeChecker.selected;
}

- (IBAction)onTermsAndConditions {
    [self.navigationController pushViewController:termsVC animated:YES];
}

- (IBAction)onPrivacyPolicy {
    [self.navigationController pushViewController:privacyVC animated:YES];
}

#pragma mark -

- (void) hideMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = YES;
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:0 color:redColor];
                         [self.signupPassword.superview border:0 color:redColor];
                         [self.signupConfirm.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showNoInternetMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Please connect to the internet to continue";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:0 color:redColor];
                         [self.signupPassword.superview border:0 color:redColor];
                         [self.signupConfirm.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showMandatoryMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Please complete mandatory fields marked with * to continue";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:3 color:redColor];
                         [self.signupEmail.superview border:3 color:redColor];
                         [self.signupPassword.superview border:3 color:redColor];
                         [self.signupConfirm.superview border:3 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showDuplicatedUsernameMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Username already in use, please choose a new username";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:3 color:redColor];
                         [self.signupEmail.superview border:0 color:redColor];
                         [self.signupPassword.superview border:0 color:redColor];
                         [self.signupConfirm.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showInvalidPasswordMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Please enter a valid password. Must contain 8 characters of which one is number and one is a letter";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:0 color:redColor];
                         [self.signupPassword.superview border:3 color:redColor];
                         [self.signupConfirm.superview border:3 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showUnmatchedPasswordMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Password does not match, please try again";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:0 color:redColor];
                         [self.signupPassword.superview border:3 color:redColor];
                         [self.signupConfirm.superview border:3 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showInvalidEmailMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Please enter a valid email address to continue";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:3 color:redColor];
                         [self.signupPassword.superview border:0 color:redColor];
                         [self.signupConfirm.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showDuplicatedEmailMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Email address already registered. Please either delete the account using this email or register a new email address";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         CGRect frame = self.signupInputView.frame;
                         frame.origin.y = self.signupMessageLabel.frame.origin.y + self.signupMessageLabel.frame.size.height;
                         self.signupInputView.frame = frame;
                         
                         [self.signupUsername.superview border:0 color:redColor];
                         [self.signupEmail.superview border:3 color:redColor];
                         [self.signupPassword.superview border:0 color:redColor];
                         [self.signupConfirm.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

@end
