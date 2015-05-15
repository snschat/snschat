//
//  FogottenUsernameVC.m
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "FogottenUsernameVC.h"
#import <MessageUI/MessageUI.h>

@implementation FogottenUsernameVC

- (IBAction)goPasswordVC:(id)sender {
    NSMutableArray* vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs removeLastObject];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onMailTo:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        //        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"username@shopnsocial.com"]];
        //        [composeViewController setSubject:@""];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
@end
