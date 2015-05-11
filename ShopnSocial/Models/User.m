//
//  User.m
//  ShopnSocial
//
//  Created by rock on 5/2/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "User.h"
#import "ExNSDate.h"
#import "ExNSString.h"

#define QB_Class_Name @"User"

static User* gCurrentUser = nil;

@interface User (Private)


@end

@implementation User

#pragma mark - class methods

+ (User*)getUserByNameSync:(NSString*)username;
{
    return [self getUserByField:@"UserName" value:username];
}

+ (User*)getUserByEmailSync:(NSString*)email;
{
    return [self getUserByField:@"Email" value:email];
}

+ (User*)getUserByFacebookSync:(NSString*)fid
{
    return [self getUserByField:@"facebookID" value:fid];
}

+ (User*)getUserByTwitterSync:(NSString*)tid
{
    return [self getUserByField:@"twitterID" value:tid];
}

+ (User*)getUserByGooglePlusSync:(NSString*)gid
{
    return [self getUserByField:@"googleID" value:gid];
}


+ (User*)getUserByField:(NSString*)field value:(NSString*)value;
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        field: value,
                                                                                        @"limit": @(1)
                                                                                        }];
    __block User* user = nil;
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           for (QBCOCustomObject* co in objects) {
                               user = [[User alloc] init];
                               [self mapFromQT:co toUser:user];
                               
                               break;
                           }
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return user;
}

+ (BOOL)createNewUserSync:(User*)user
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    user.customObject = [QBCOCustomObject customObject];
    QBCOCustomObject* object = user.customObject;
    
    NSString* md5Password = user.Password;
    
    object.className = QB_Class_Name;
    
    [object.fields setObject:user.Username forKey:@"UserName"];
    [object.fields setObject:user.Email forKey:@"Email"];
    
    if (user.Location != nil) [object.fields setObject:user.Location forKey:@"Location"];
    if (user.Birthday != nil) [object.fields setObject:[user.Birthday stringWithFormat:[NSDate dateFormatString]] forKey:@"Birthday"];
    if (user.Gender != nil) [object.fields setObject:user.Gender forKey:@"Gender"];
    
    if (user.FacebookID != nil) [object.fields setObject:user.FacebookID forKey:@"facebookID"];
    if (user.TwitterID != nil) [object.fields setObject:user.TwitterID forKey:@"twitterID"];
    if (user.GoogleID != nil) [object.fields setObject:user.GoogleID forKey:@"googleID"];
    
    __block User* __user = user;
    [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        __user.customObject = object;
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        __user.customObject = nil;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (user.customObject == nil) return NO;
    
    QBUUser* qbuser = [QBUUser user];
    qbuser.login = user.Email;
    qbuser.email = user.Email;
    qbuser.password = md5Password;
    
    [QBRequest signUp:qbuser successBlock:^(QBResponse *response, QBUUser *user) {
        __user.qbuUser = user;
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        __user.qbuUser = nil;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return user.customObject != nil;
}

+ (User*)changePassword:(User*)user oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    if (user.qbuUser == nil) return nil;
    
    QBUUser* qbuUser = user.qbuUser;
    
    __block User* __user = user;
    
    qbuUser.oldPassword = oldPassword;
    qbuUser.password = newPassword;
    
    [QBRequest updateUser:qbuUser successBlock:^(QBResponse *response, QBUUser *user) {
        __user.qbuUser = user;
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        __user = nil;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return __user;
}

+ (User*)resetPassword:(User*)user
{
    if (user.customObject == nil) return nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block User* __user = user;
    
    [QBRequest resetUserPasswordWithEmail:user.Email
                             successBlock:^(QBResponse *response) {
                                 dispatch_semaphore_signal(sema);
                             } errorBlock:^(QBResponse *response) {
                                 __user = nil;
                                 dispatch_semaphore_signal(sema);
                             }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    [user setNeedChangePasswordSync:YES];
    
    return __user;
};

#pragma mark -

+ (User*)currentUser
{
    return gCurrentUser;
}

+ (void)setCurrentUser:(User*)user
{
    gCurrentUser = user;
}

#pragma mark -

+ (User*)loginUserSync:(NSString*)email password:(NSString*)password
{
    User* user = [self getUserByEmailSync:email];
    
    if (user == nil) return nil;
    
    QBUUser* qbuUser = [self loginQBUUserSync:user.Email password:password];
    
    if (qbuUser == nil) return nil;
    
    user.qbuUser = qbuUser;
    
    return user;
}

+ (QBUUser*)loginQBUUserSync:(NSString*)username password:(NSString*)password
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block QBUUser* __user = nil;
    [QBRequest logInWithUserLogin:username
                         password:password
                     successBlock:^(QBResponse *response, QBUUser *user) {
                         __user = user;
                         dispatch_semaphore_signal(sema);
                     } errorBlock:^(QBResponse *response) {
                         __user = nil;
                         dispatch_semaphore_signal(sema);
                     }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return __user;
}

+ (void)mapFromQT:(QBCOCustomObject*)co toUser:(User*)user
{
    NSString* birthday = co.fields[@"Birthday"];
    
    user.customObject = co;
    user.Username = co.fields[@"UserName"];
    user.Email = co.fields[@"Email"];
    user.Location = co.fields[@"Location"];
    user.Birthday = birthday == nil ? nil : [NSDate dateFromString:birthday withFormat:[NSDate dateFormatString]];
    user.Gender = co.fields[@"Gender"];
    
    user.FacebookID = co.fields[@"facebookID"];
    user.TwitterID = co.fields[@"twitterID"];
    user.GoogleID = co.fields[@"googleID"];
    
    user.qbuUser = nil;
}

#pragma mark - instance methods

- (BOOL) isNeedChangePasswordSync
{
    return (BOOL)self.customObject.fields[@"needChangePassword"];
}

- (BOOL) setNeedChangePasswordSync:(BOOL)isNeed
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [self.customObject.fields setValue:[NSNumber numberWithBool:isNeed] forKey:@"needChangePassword"];
    
    __block BOOL __result = NO;
    [QBRequest updateObject:self.customObject
               successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                   __result = YES;
                   dispatch_semaphore_signal(sema);
               } errorBlock:^(QBResponse *response) {
                   __result = NO;
                   dispatch_semaphore_signal(sema);
               }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return __result;
}

@end
