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

+ (QBUUser *) getQBUserFromUserSync:(User *) user
{
    if(user.qbuUser != nil)
        return user.qbuUser;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSArray * emailArr = @[user.Email];
    
    __block QBUUser * qbUser = nil;
    
    [QBRequest usersWithEmails:emailArr successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
        for(QBUUser * _qbUser in users)
        {
            qbUser = _qbUser;
            break;
        }
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return qbUser;
}

+ (User *) getUserByIDSync:(NSInteger) userID
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block User * user = nil;
    __block QBUUser * qbUser = nil;
    [QBRequest userWithID: userID successBlock:^(QBResponse *response, QBUUser *_qbUser) {
        qbUser = _qbUser;
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if(qbUser)
    {
        user = [self getUserByEmailSync: qbUser.email];
        user.UserID = userID;
        user.qbuUser = qbUser;
    }
    return user;
}

+ (NSArray *) getUsersFromContactsSync:(NSArray *) contacts
{
    NSMutableArray * userArr = [NSMutableArray array];
    
    for(QBContactListItem * contact in contacts)
    {
        User * user = [self getUserByIDSync: contact.userID];
        if(user != nil)
            [userArr addObject: user];
        else
            [[QBChat instance] removeUserFromContactList: contact.userID];
    }
    return userArr;
}

+ (BOOL) setCurrentUserStatusSync:(NSString *) status
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block BOOL bResult;
    QBCOCustomObject * object = [QBCOCustomObject customObject];
    object.className = QB_Class_Name;

    User * curUser = [User currentUser];
    
    [object.fields setObject:status forKey:@"status"];
    object.ID = curUser.customObject.ID;
    
    [QBRequest updateObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
        dispatch_semaphore_signal(sema);
        [curUser updateFromQT: object];
        bResult = YES;
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Response error: %@", [response.error description]);
        bResult = NO;
        dispatch_semaphore_signal(sema);
    }];
    
    [[QBChat instance] sendPresenceWithStatus: status];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return bResult;
}

+ (NSArray *) searchUsersByField:(NSString *) field value:(NSString *) value
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        field : value
                                                                                        
                                                                                        }];
    __block NSMutableArray * resultArr;
    resultArr = [NSMutableArray array];
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           for (QBCOCustomObject* co in objects) {
                               User * user = [[User alloc] init];
                               [self mapFromQT:co toUser:user];
                               [resultArr addObject: user];
                           }
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return resultArr;

}

+ (User*)getUserByField:(NSString*)field value:(NSString*)value
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
+ (NSArray *) searchUsersByEmailPrefixSync: (NSString *) email
{
    return [self searchUsersByField:@"Email[ctn]" value:email];
}

+ (NSArray *) searchUsersByNamePrefixSync:(NSString *) prefix
{
    return [self searchUsersByField: @"UserName[ctn]" value:prefix];
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
//    [object.fields setObject: @"Online" forKey:@"status"];
    
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
        NSLog(@"%@", response);
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (user.customObject == nil) return NO;
    
    QBUUser* qbuser = [QBUUser user];
    qbuser.login = user.Email;
    qbuser.email = user.Email;
    qbuser.fullName = user.Username;
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
    user.UserID = qbuUser.ID;
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
                         __user.password = password;
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
    user.Status = co.fields[@"status"];
    user.qbuUser = nil;
}

#pragma mark - instance methods
- (void) updateFromQT:(QBCOCustomObject *) co
{
    NSString* birthday = co.fields[@"Birthday"];
    self.customObject = co;
    self.Username = co.fields[@"UserName"];
    self.Email = co.fields[@"Email"];
    self.Location = co.fields[@"Location"];
    self.Birthday = birthday == nil ? nil : [NSDate dateFromString:birthday withFormat:[NSDate dateFormatString]];
    self.Gender = co.fields[@"Gender"];
    
    self.FacebookID = co.fields[@"facebookID"];
    self.TwitterID = co.fields[@"twitterID"];
    self.GoogleID = co.fields[@"googleID"];
    self.Status = co.fields[@"status"];
}

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

#pragma NSObject override
- (BOOL) isEqual:(id)object
{
    User * obj = object;
    if(self.UserID > 0 && obj.UserID > 0 && self.UserID == obj.UserID)
    {
        return true;
    }
    else
        return false;
    
}
@end
