//
//  SplashVC.m
//  ShopnSocial
//
//  Created by rock on 4/21/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SplashVC.h"
#import "ExNetwork.h"


#import "Global.h"
#import "User.h"

@interface SplashVC ()
{
    bool isReachableInternet;
}
@end

@implementation SplashVC

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
        
        QBSessionParameters *parameters = [QBSessionParameters new];
        parameters.userLogin = @"mazb19";
        parameters.userPassword = @"evoodioz";
        
        [QBRequest createSessionWithExtendedParameters:parameters
                                          successBlock:^(QBResponse *response, QBASession *session) {
                                              NSLog(@"Session created");
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                                                  NSArray* countries = [Country getCountriesSync];
                                                  NSLog(@"Success %lu countries", (unsigned long)countries.count);
                                                  [self gotoNext];
                                              });
                                          } errorBlock:^(QBResponse *response) {
                                              NSLog(@"Session create failed");
                                          }];
        
//        [NSTimer scheduledTimerWithTimeInterval:2.0
//                                         target:self
//                                       selector:@selector(onSplashTimer:)
//                                       userInfo:nil
//                                        repeats:NO];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* useremail = [Global sharedGlobal].LoginedUserEmail;

        if (useremail != nil)
        {
            User* user = [User getUserByEmailSync:useremail];
            
            if (user != nil)
            {
                NSString* qusername = user.Email;
                NSString* qpassword = user.QPassword;
                
                QBUUser* qbuUser = [User loginQBUUserSync:qusername password:qpassword];
                user.qbuUser = qbuUser;
                [User setCurrentUser:user];
                
                UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowserHomeVC"];
                [self.navigationController pushViewController:vc animated:YES];
                
                return;
            }
        }
        
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:vc animated:YES];
    });
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
