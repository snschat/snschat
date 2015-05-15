//
//  ResetPasswordVC.m
//  ShopnSocial
//
//  Created by rock on 5/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <MessageUI/MessageUI.h>

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
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIKeyboardWillShowNotification
     object:nil
     queue:mainQueue
     usingBlock:^(NSNotification *note) {
         NSDictionary* dict = note.userInfo;
         NSValue* frame = (NSValue*)[dict valueForKey:UIKeyboardFrameEndUserInfoKey];
         
         [UIView animateWithDuration:0.3f animations:^{
             CGRect frame = self.view.frame;
             frame.origin.y = -190;
             self.view.frame = frame;
         }];
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIKeyboardWillHideNotification
     object:nil
     queue:mainQueue
     usingBlock:^(NSNotification *note) {
         [UIView animateWithDuration:0.3f animations:^{
             CGRect frame = self.view.frame;
             frame.origin.y = 0;
             self.view.frame = frame;
         }];
     }];
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
        [self.txtEmail resignFirstResponder];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            User* user = [User getUserByEmailSync:email];
            
            if (user == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showContactUsMessage];
                });
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

- (IBAction)onMailPassword:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        //        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"password@shopnsocial.com"]];
        //        [composeViewController setSubject:@""];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

- (IBAction)goForgottenUsername {
    NSMutableArray* vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs removeLastObject];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FogottenUsernameVC"];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}


- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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
    self.resetView.hidden = YES;
    self.infoResetPassword.hidden = NO;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self onSend];
    return YES;
}
@end
