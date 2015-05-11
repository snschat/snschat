//
//  ResetPasswordVC.m
//  ShopnSocial
//
//  Created by rock on 5/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "ExUILabel+AutoSize.h"
#import "ExUIView+Border.h"
#import "ExNetwork.h"
#import "ExNSString.h"
#import "MBProgressHUD.h"

#import "Global.h"
#import "User.h"

@interface ResetPasswordVC ()
{
    UIColor* redColor;
}
@end

@implementation ResetPasswordVC

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    redColor = self.infoNoInternet.textColor;
}

- (IBAction)onSend {
    NSString* email = self.txtEmail.text;
    
    if ([email isValidEmail] == false)
    {
        [self showContactUsMessage];
    }
    else
    {
        [self hideMessage:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            User* user = [User getUserByEmailSync:email];
            
            if (user == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showContactUsMessage];
                });
                return;
            }
            else
            {
                user = [User resetPassword:user];
                
                if (user != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showResetedMessage];
                    });
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
}

- (IBAction)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hideMessage:(BOOL)isAnimated {
    
    void (^animationBlock)(void)  = ^{
        self.infoNoInternet.hidden = YES;
        self.infoContactUs.hidden = YES;
        self.interuptView.hidden = YES;
        
        CGRect frame = self.inputView.frame;
        frame.origin.y = self.infoNoInternet.frame.origin.y;
        self.inputView.frame = frame;
        
        [self.emailField border:0 color:redColor];
        
        self.inputView.alpha = 1;
        self.description1.alpha = 1;
        self.description2.alpha = 1;

    };
    
    if (isAnimated)
    {
        [UIView animateWithDuration:0.3
                         animations:animationBlock
                         completion:^(BOOL finished) {
                         }];
    }
    else
    {
        animationBlock();
    }
    
}

- (void) showNoInternetMessage {
    [self hideMessage:NO];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.infoNoInternet.hidden = NO;
                         self.interuptView.hidden = NO;
                         [self.interuptView.superview bringSubviewToFront:self.interuptView];
                         
                         CGRect frame = self.inputView.frame;
                         frame.origin.y = self.infoNoInternet.frame.origin.y + self.infoNoInternet.frame.size.height;
                         self.inputView.frame = frame;
                         
                         self.inputView.alpha = 0.3;
                         self.description1.alpha = 0.3;
                         self.description2.alpha = 0.4;
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showResetedMessage {
    [self hideMessage:NO];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.infoResetPassword.hidden = NO;
                         self.interuptView.hidden = NO;
                         [self.interuptView.superview bringSubviewToFront:self.interuptView];
                         
                         CGRect frame = self.inputView.frame;
                         frame.origin.y = self.infoNoInternet.frame.origin.y + self.infoNoInternet.frame.size.height;
                         self.inputView.frame = frame;
                         
                         self.inputView.alpha = 0.3;
                         self.description1.alpha = 0.3;
                         self.description2.alpha = 0.4;
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void) showContactUsMessage {
    [self hideMessage:NO];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.infoContactUs.hidden = NO;
                         
                         CGRect frame = self.inputView.frame;
                         frame.origin.y = self.infoContactUs.frame.origin.y + self.infoContactUs.frame.size.height;
                         self.inputView.frame = frame;
                         
                         [self.emailField border:3 color:redColor];
                         
                     } completion:^(BOOL finished) {
                     }];
}

@end
