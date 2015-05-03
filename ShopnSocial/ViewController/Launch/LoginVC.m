//
//  LoginVC.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "LoginVC.h"
#import "ExUILabel+AutoSize.h"
#import "ExUIView+Border.h"
#import "MBProgressHUD.h"

#import "User.h"

@interface LoginVC ()
{
    UIColor* redColor;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    redColor = self.loginMessageLabel.textColor;
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

- (IBAction)onFacebook
{
}

- (IBAction)onTwitter
{
}

- (IBAction)onGooglePlus
{
}

- (IBAction)onSignin
{
    if (self.loginUsername.text.length == 0 ||
        self.loginPassword.text.length == 0) {
        [self showLoginLockedMessage];
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoginMessage];
    });
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        User* user = [User loginUserSync:self.loginUsername.text
                                password:self.loginPassword.text];
        
        if (user == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoginIncorrectMessage];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onLoginSuccess];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });

    });
}

- (IBAction)onForgotPassword
{
    [self hideLoginMessage];
}

#pragma mark -

- (void)onLoginSuccess
{
    NSLog(@"Login Successed - %@", [User currentUser]);
}

#pragma mark -

- (void) hideLoginMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loginMessageLabel.hidden = YES;
                         
                         CGRect frame = self.loginInputView.frame;
                         frame.origin.y = self.loginMessageLabel.frame.origin.y;
                         self.loginInputView.frame = frame;
                         
                         [self.loginUsername.superview border:0 color:redColor];
                         [self.loginPassword.superview border:0 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showLoginIncorrectMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loginMessageLabel.hidden = NO;
                         self.loginMessageLabel.text = @"Username and/or Password are incorrect";
                         
                         [self.loginMessageLabel fitHeight];
                         
                         CGRect frame = self.loginInputView.frame;
                         frame.origin.y = self.loginMessageLabel.frame.origin.y + self.loginMessageLabel.frame.size.height;
                         self.loginInputView.frame = frame;
                         
                         [self.loginUsername.superview border:3 color:redColor];
                         [self.loginPassword.superview border:3 color:redColor];
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showLoginLockedMessage
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.loginMessageLabel.hidden = NO;
                         self.loginMessageLabel.text = @"Your account has been locked for security reasons. We have sent a temporary password to your registered email address";
                         
                         [self.loginMessageLabel fitHeight];
                         
                         CGRect frame1 = self.loginInputView.frame;
                         frame1.origin.y = self.loginMessageLabel.frame.origin.y + self.loginMessageLabel.frame.size.height;
                         self.loginInputView.frame = frame1;
                         
                         [self.loginUsername.superview border:3 color:redColor];
                         [self.loginPassword.superview border:3 color:redColor];
                     } completion:^(BOOL finished) {
                     }];

}


@end
