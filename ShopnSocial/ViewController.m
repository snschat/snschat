//
//  ViewController.m
//  ShopnSocial
//
//  Created by rock on 4/21/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ViewController.h"
#import "ExNetwork.h"

@interface ViewController ()
{
    bool isReachableInternet;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkInternet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void) checkInternet
{
    isReachableInternet = [ExNetwork IsReachableInternet];
    
    if (isReachableInternet)
    {
        [self showInternet];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(onSplashTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else
    {
        [self showNoInternet];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(onCheckTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void) onSplashTimer:(NSTimer*) timer
{
    [self gotoNext];
}

- (void) onCheckTimer:(NSTimer*) timer
{
    [self checkInternet];
}

- (void) gotoNext
{
    NSLog(@"go to next");
}

- (void) showInternet
{
    self.logoImageView.hidden = NO;
    self.logoRedImageView.hidden = YES;
    self.noInternetLabel.hidden = YES;
}

- (void) showNoInternet
{
    self.logoImageView.hidden = YES;
    self.logoRedImageView.hidden = NO;
    self.noInternetLabel.hidden = NO;
}

@end
