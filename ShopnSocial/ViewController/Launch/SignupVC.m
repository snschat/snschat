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
#import "ExNetwork.h"
#import "ExNSString.h"
#import "ExNSDate.h"
#import "MBProgressHUD.h"

#import "Global.h"
#import "Country.h"
#import "User.h"

@interface SignupVC ()
{
    UIColor* redColor;
    
    UIViewController* termsVC;
    UIViewController* privacyVC;
    
    bool isReachableInternet;
    
    NSArray* countries;
    NSArray* countryNames;
    int selectedCountryIdx;
    
    NSArray* genders;
    NSArray* genderNames;
    int selectedGenderIdx;
    
    NSDate* birthday;
    
    ListPopoverVC* locationPopoverVC;
    ListPopoverVC* genderPopoverVC;
    DatePopoverVC* datePopoverVC;
}
@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    redColor = self.signupMessageLabel.textColor;
    
    [self.interrupterView.superview bringSubviewToFront:self.interrupterView];
    self.interrupterView.hidden = YES;
    
    [self populateCountry];
    [self populateGender];

    termsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsVC"];
    privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyVC"];
    
    selectedGenderIdx = -1;
    selectedCountryIdx = -1;
    birthday = nil;
    
    locationPopoverVC = nil;
    genderPopoverVC = nil;
    datePopoverVC = nil;
    
    if (self.prefilleddUser != nil) {
        self.signupUsername.text = self.prefilleddUser.Username;
        self.signupEmail.text = self.prefilleddUser.Email;
        
        int idx = 0;
        for (NSString* gn in genders) {
            if ([gn isEqualToString:self.prefilleddUser.Gender])
            {
                self.signupGender.text = genderNames[idx];
                selectedGenderIdx = idx;
                break;
            }
            idx ++;
        }
        
        self.signupPassword.text = [[NSString stringWithFormat:@"pw%@%@%@%@%@",
                                    self.prefilleddUser.Username,
                                    self.prefilleddUser.Email,
                                    self.prefilleddUser.FacebookID,
                                    self.prefilleddUser.TwitterID,
                                    self.prefilleddUser.GoogleID
                                     ] MD5String];
        self.signupConfirm.text = self.signupPassword.text;
        
        self.signupPassword.superview.hidden = YES;
        self.signupConfirm.superview.hidden = YES;
        self.imgStar3.hidden = YES;
        self.imgStar4.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    NSArray* fields = @[
                        self.signupEmail.superview,
                        self.signupPassword.superview,
                        self.signupConfirm.superview,
                        self.signupLocation.superview,
                        self.signupBirthday.superview,
                        self.signupGender.superview,
                        ];
    
    float top = self.signupUsername.frame.origin.y;
    float gap  = 50;
    for (UIView* vw in fields) {
        if (vw.hidden) continue;
        CGRect frame = vw.frame;
        frame.origin.y = top + gap;
        vw.frame = frame;
        
        top = frame.origin.y;
    }
    
    CGRect frame = self.signupAgreeChecker.superview.frame;
    frame.origin.y = top + gap + 2;
    self.signupAgreeChecker.superview.frame = frame;

    frame = self.imgStar5.frame;
    frame.origin.y = top + gap + 2 + 14;
    self.imgStar5.frame = frame;
    
    top = top + gap + 2;
    
    frame = self.singupButton.frame;
    frame.origin.y = top + 44;
    self.singupButton.frame = frame;

    frame = self.cancelButton.frame;
    frame.origin.y = top + 44;
    self.cancelButton.frame = frame;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"location"]) {
        locationPopoverVC = (ListPopoverVC*)segue.destinationViewController;
        genderPopoverVC = nil;
        
        locationPopoverVC.items = countryNames;
        locationPopoverVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"gender"]) {
        locationPopoverVC =nil;
        genderPopoverVC = (ListPopoverVC*)segue.destinationViewController;
        
        genderPopoverVC.items = genderNames;
        genderPopoverVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"date"]) {
        datePopoverVC = (DatePopoverVC*)segue.destinationViewController;
        datePopoverVC.delegate = self;
        datePopoverVC.selectedDate = birthday;
    }
}


#pragma marl -

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (locationPopoverVC != nil) {
        self.signupLocation.text = countryNames[indexPath.row];
        selectedCountryIdx = (int)indexPath.row;
        
        [locationPopoverVC dismissViewControllerAnimated:YES completion:nil];
    }
    else if (genderPopoverVC != nil) {
        self.signupGender.text = genderNames[indexPath.row];
        selectedGenderIdx = (int)indexPath.row;
        
        [genderPopoverVC dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didSelectDate:(NSDate *)date
{
    birthday = date;
    self.signupBirthday.text = [birthday stringWithFormat:@"MMMM d, yyyy"];
}

- (void) populateCountry
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        countries = [Country getCountriesSync];
        NSMutableArray* conames = [NSMutableArray array];
        for (Country* co in countries) {
            [conames addObject:co.Name];
        }
        countryNames = conames;        
    });
}

- (void) populateGender
{
    genders = @[@"M", @"F", @"O", @"N"];
    genderNames = @[@"Male", @"Femal", @"Other", @"None of your business"];
}

#pragma mark -

- (IBAction)onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSignup {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self hideMessage:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        User* newUser = [self checkValidationAllSync];
        
        NSLog(@"check done -------------- ");
        
        if (newUser == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            return;
        }

        NSLog(@"Will register new user %@", newUser);
        
        BOOL result = [User createNewUserSync:newUser];
        
        // if sucess to create new user, login with user info.
        if (result) {
            NSString* username = newUser.Email;
            NSString* qpassword = newUser.Password;
            
            QBUUser* qbuUser = [User loginQBUUserSync:username password:qpassword];
            newUser.qbuUser = qbuUser;
            
            [User setCurrentUser:newUser];
            
            // save current user info with logined user info.
            [Global sharedGlobal].LoginedUserEmail = newUser.Email;
            [Global sharedGlobal].LoginedUserPassword = newUser.Password;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowserHomeVC"];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)onDidSignup
{
    NSLog(@"Signed up as succesful.");
}

#pragma mark -

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

- (User*) checkValidationAllSync
{
    // LR.90 check internet status.
    if (![self checkInternet])
    {
        [self showNoInternetMessage];
        return nil;
    }
    
    NSString* username = self.signupUsername.text;
    NSString* email = self.signupEmail.text;
    NSString* password = self.signupPassword.text;
    NSString* confirm = self.signupConfirm.text;
    bool isAgreed = self.signupAgreeChecker.selected;
    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (username.length != 0)
    {
    }
    
    // LR.95, 96, 97, 98, 107: check mandatory fields
    if (username.length == 0 ||
        email.length == 0 ||
        password.length == 0 ||
        confirm.length == 0 ||
        !isAgreed)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMandatoryMessage];
        });
        return nil;
    }

    // LR.101
    if (![self checkEmail:email])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showInvalidEmailMessage];
        });
        return nil;
    }
    
    // LR.103, 104, 105
    if (!password.isValidPassword) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showInvalidPasswordMessage];
        });
        return nil;
    }
    
    // LR.106
    if (![password isEqualToString:confirm])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showUnmatchedPasswordMessage];
        });
        return nil;
    }
    
    
    // LR.108, 99 check if username exists
    if ([self isExistUsername:username])
    {
        [self showDuplicatedUsernameMessage];
        return nil;
    }
    // LR.102
    if([self isExistEmail:email])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showDuplicatedEmailMessage];
        });
        return nil;
    }

    
    User* userData = self.prefilleddUser != nil ? self.prefilleddUser : [[User alloc] init];
    userData.Username = username;
    userData.Email = email;
    userData.Password = password;
    userData.Location = selectedCountryIdx >= 0 ? ((Country*)countries[selectedCountryIdx]).Code : @(0);
    userData.Birthday = birthday;
    userData.Gender = selectedGenderIdx >= 0 ? genders[selectedGenderIdx] : @"N";
    
    
    
    return userData;
}

- (bool) checkInternet
{
    isReachableInternet = [ExNetwork IsReachableInternet];
    
    if (isReachableInternet)
    {
        [self hideMessage];
        return true;
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(onCheckTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    return false;
}

- (void) onCheckTimer:(NSTimer*) timer
{
    [self checkInternet];
}

// LR.99 choose a username already in use.
// check if username exist in the using on the server
- (bool) isExistUsername:(NSString*) username
{
    User* existUser = [User getUserByNameSync:username];
    
    return existUser != nil;
}

// LR.101 invalid email address
- (bool) checkEmail:(NSString*) email
{
    return email.isValidEmail;
}

// LR.102 duplicated email address
- (bool) isExistEmail:(NSString*) email
{
    User* existUser = [User getUserByEmailSync:email];
    
    return existUser != nil;
}

#pragma mark -

- (void) hideMessage
{
    [self hideMessage:YES];
}

- (void) hideMessage: (BOOL)isAnimated
{
    void (^animationBlock)(void)  = ^{
        self.signupMessageLabel.hidden = YES;
        [self.signupInputView.superview bringSubviewToFront:self.signupInputView];
        self.signupInputView.alpha = 1;
        self.pageDescriptionLabel.alpha = 1;
        self.interrupterView.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:0.5];
        
        
        CGRect frame = self.signupInputView.frame;
        frame.origin.y = self.signupMessageLabel.frame.origin.y;
        self.signupInputView.frame = frame;
        
        [self.signupUsername.superview border:0 color:redColor];
        [self.signupEmail.superview border:0 color:redColor];
        [self.signupPassword.superview border:0 color:redColor];
        [self.signupConfirm.superview border:0 color:redColor];
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

- (void) showNoInternetMessage
{
    [self hideMessage:NO];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.signupMessageLabel.hidden = NO;
                         self.signupMessageLabel.text = @"Please connect to the internet to continue";
                         
                         [self.signupMessageLabel fitHeight];
                         
                         self.signupInputView.alpha = 0.3;
                         self.pageDescriptionLabel.alpha = 0.3;
                         [self.interrupterView.superview bringSubviewToFront:self.interrupterView];
                         self.interrupterView.hidden = NO;
                         
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
    [self hideMessage:NO];
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
    [self hideMessage:NO];
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
    [self hideMessage:NO];
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
    [self hideMessage:NO];
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
    [self hideMessage:NO];
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
    [self hideMessage:NO];
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
