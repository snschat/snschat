//
//  LoginVC.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatService.h"
#import "LoginVC.h"
#import "ExUILabel+AutoSize.h"
#import "ExUIView+Border.h"
#import "MBProgressHUD.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "FHSTwitterEngine.h"
#import <Twitter/Twitter.h>

#import "Constants.h"
#import "Global.h"
#import "User.h"
#import "SignupVC.h"

@interface LoginVC () <GPPSignInDelegate>
{
    UIColor* redColor;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.imgBackground.layer setMinificationFilter:kCAFilterNearest];

    redColor = self.loginMessageLabel.textColor;
    
    [GPPSignIn sharedInstance].shouldFetchGooglePlusUser = YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    [GPPSignIn sharedInstance].delegate = self;
    
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIKeyboardWillChangeFrameNotification
     object:nil
     queue:mainQueue
     usingBlock:^(NSNotification *note) {
         NSDictionary* dict = note.userInfo;
         NSValue* frame = (NSValue*)[dict valueForKey:UIKeyboardFrameEndUserInfoKey];
         [self onShowKeyboard:frame.CGRectValue];
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIKeyboardWillHideNotification
     object:nil
     queue:mainQueue
     usingBlock:^(NSNotification *note) {
         [self onHideKeyboard];
     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    NSLog(@"loginWithFB");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ACAccountStore * storeAccount = [[ACAccountStore alloc]init];
    
    ACAccountType *facebookAccountType = [storeAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{ACFacebookAppIdKey : FBAppID,
                              ACFacebookPermissionsKey : @[ @"email", @"read_friendlists"],
                              ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    [storeAccount requestAccessToAccountsWithType:facebookAccountType
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
                                           if (granted)
                                           {
                                               // At this point we can assume that we have access to the Facebook account
                                               NSArray *accounts = [storeAccount accountsWithAccountType:facebookAccountType];
                                               
                                               // Optionally save the account
                                               [storeAccount saveAccount:[accounts lastObject] withCompletionHandler:nil];
                                               
                                               [self getFacebookProfile:[accounts lastObject]];
                                               
                                               NSLog(@"facebook account = %@",[accounts lastObject]);
                                           }
                                           else
                                           {
                                               [self signInWithFBApp];
                                           }
                                       }];
}

- (IBAction)onTwitter
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        if (success)
        {
            NSLog(@"Twitter login success");
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString* tid = [FHSTwitterEngine sharedEngine].authenticatedID;
                NSString* username = [FHSTwitterEngine sharedEngine].authenticatedUsername;
                
                NSLog(@"Twitter ID %@", tid);
                NSLog(@"Twitter username %@", username);
                
                User* user = [User getUserByTwitterSync:tid];
                
                if (user != nil) [self loginWithUser:user];
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        User*  user = [[User alloc] init];
                        user.TwitterID = tid;
                        user.Username = username;
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        SignupVC* vc = (SignupVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
                        vc.prefilleddUser = user;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            });
        }
        else
        {
            NSLog(@"Twitter login failure");
        }
    }];
    [self presentViewController:loginController animated:YES completion:nil];

}

- (IBAction)onGooglePlus
{
    NSLog(@"Start Google Login");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)onSignin
{
    if (self.loginUsername.text.length == 0 ||
        self.loginPassword.text.length == 0) {
        [self showLoginIncorrectMessage];
        
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
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        else {
            // if success to login user, save its info as logined user info
            [Global sharedGlobal].LoginedUserEmail = self.loginUsername.text;
            [Global sharedGlobal].LoginedUserPassword = self.loginPassword.text;
            [Global sharedGlobal].currentUser = user;
            
            [[Global sharedGlobal] initUserData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onLoginSuccess];
            });
        }
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowserHomeVC"];
        [self.navigationController pushViewController:vc animated:YES];
    });
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

#pragma mark - Social Login


#pragma mark - Facebook
- (void)signInWithFBApp
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // If the session state is any of the two "open" states when the button is clicked
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            [FBSession.activeSession closeAndClearTokenInformation];
            
            // If the session state is not any of the two "open" states when the button is clicked
        } else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 
                 if (session.isOpen) {
                     
                     [[FBRequest requestForMe] startWithCompletionHandler:
                      ^(FBRequestConnection *connection,
                        NSDictionary<FBGraphUser> *user,
                        NSError *error) {
                          if (!error) {
                              NSMutableDictionary *mdict = (NSMutableDictionary*)user;
                              
                              [self loginFBUser:mdict];
                          }
                          else
                          {
                              NSLog(@"Error in FBRequest");
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                              });
                          }
                      }];
                 }
             }];
        }
        
    });
}

- (void)getFacebookProfile:(ACAccount*)fbAccount{
    NSURL *meurl = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *merequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:meurl
                                                 parameters:nil];
    
    merequest.account = fbAccount;
    
    [merequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {
            NSError* error;
            NSMutableDictionary *mdict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:kNilOptions
                                                                           error:&error];
            [self loginFBUser:mdict];
        }
        else
        {
            NSLog(@"Error in FBRequest");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });

        }
        
    }];
    
}

-(void)loginFBUser:(NSMutableDictionary*)mDictUserInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* fid = mDictUserInfo[@"id"];
        NSString* gender = mDictUserInfo[@"gender"];
        NSString* name = mDictUserInfo[@"name"];
        
        if ([gender isEqual:@"male"]) gender = @"M";
        else gender = @"F";
        
        NSLog(@"Facebook User Info: %@", mDictUserInfo);
        
        User* user = [User getUserByFacebookSync:fid];
        
        if (user != nil) [self loginWithUser:user];
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                User*  user = [[User alloc] init];
                user.FacebookID = fid;
                user.Gender = gender;
                user.Username = name;
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                SignupVC* vc = (SignupVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
                vc.prefilleddUser = user;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    });
}

#pragma mark - Google plus
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    } else {
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    } else {
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSString* gid = person.identifier;
                            NSString* gender = person.gender;
                            NSString* name = [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName];
                            NSString* email = [GPPSignIn sharedInstance].authentication.userEmail;
                            
                            if ([gender isEqual:@"male"]) gender = @"M";
                            else gender = @"F";
                            
                            User* user = [User getUserByGooglePlusSync:gid];
                            
                            if (user != nil) [self loginWithUser:user];
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    User*  user = [[User alloc] init];
                                    user.GoogleID = gid;
                                    user.Gender = gender;
                                    user.Username = name;
                                    user.Email = email;
                                    
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                    SignupVC* vc = (SignupVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
                                    vc.prefilleddUser = user;
                                    [self.navigationController pushViewController:vc animated:YES];
                                });
                            }
                        });
                        
                    }
                }];
    }
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
    //    [[self navigationController] pushViewController:viewController animated:YES];
    
    NSLog(@"Present Sign in");
}


#pragma mark -

- (void) loginWithUser:(User*)user
{
    [Global sharedGlobal].LoginedUserEmail = user.Email;
    
    [Global sharedGlobal].currentUser = user;
    [[Global sharedGlobal] initUserData];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self onLoginSuccess];
    });
}


#pragma mark -
- (void) onShowKeyboard:(CGRect) keyboardFrame
{
    self.view.frame = CGRectMake(
                                 0,
                                 keyboardFrame.origin.y*1.3 - self.view.frame.size.height,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
}

- (void) onHideKeyboard
{
    self.view.frame = CGRectMake(
                                 0,
                                 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
//    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }];
}
@end
