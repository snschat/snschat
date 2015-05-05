//
//  BrowserHomeVC.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "BrowserHomeVC.h"
#import "C360PopoverBackgroundView.h"

@implementation BrowserHomeVC


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", segue);
    if ([segue.class isSubclassOfClass:[UIStoryboardPopoverSegue class]])
    {
        UIStoryboardPopoverSegue* popsegue = (UIStoryboardPopoverSegue*)segue;
        popsegue.popoverController.popoverBackgroundViewClass = [C360PopoverBackgroundView class];
    }
}

#pragma mark -

- (IBAction)onSlideUp:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController pushViewController:vc animated:NO];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//                     }];
}


- (IBAction)onTouchSliderButton {

    if (self.chatbar.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.chatbar.frame;
                             frame.origin.x = -frame.size.width;
                             self.chatbar.frame = frame;
                         } completion:^(BOOL finished) {
                             [self.buttonChatSlider setImage:[UIImage imageNamed:@"button_blue_right"] forState:UIControlStateNormal];
                         }
         ];
    }
    else if (self.chatbar.frame.origin.x == -self.chatbar.frame.size.width) {
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = self.chatbar.frame;
                             frame.origin.x = 0;
                             self.chatbar.frame = frame;
                         } completion:^(BOOL finished) {
                             [self.buttonChatSlider setImage:[UIImage imageNamed:@"button_blue_left"] forState:UIControlStateNormal];
                         }
         ];
    }
}

@end
