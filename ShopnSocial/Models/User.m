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

+ (User*)getUserByNameSync:(NSString*)username;
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"UserName": username,
                                                                                        @"limit": @(1)
                                                                                        }];
    __block User* user = nil;
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           for (QBCOCustomObject* co in objects) {
                               user = [User new];
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

+ (User*)getUserByEmailSync:(NSString*)email;
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"Email": email,
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
    
    NSString* md5Password = [user.Password MD5String];
    
    object.className = QB_Class_Name;
    
    [object.fields setObject:user.Username forKey:@"UserName"];
    [object.fields setObject:user.Email forKey:@"Email"];
    [object.fields setObject:md5Password  forKey:@"Password"];
    [object.fields setObject:user.Location forKey:@"Location"];
    [object.fields setObject:[user.Birthday stringWithFormat:[NSDate dateFormatString]] forKey:@"Birthday"];
    [object.fields setObject:user.Gender forKey:@"Gender"];
    
    [object.fields setObject:md5Password forKey:@"QPassword"];
    
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
    NSString* md5Password = [password MD5String];
    
    if (user == nil) return nil;
    
    if ([md5Password isEqual:user.Password] == false) return nil;
    
    QBUUser* qbuUser = [self loginQBUUserSync:user.Email password:user.QPassword];
    
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
    user.Password = co.fields[@"Password"];
    user.Location = co.fields[@"Location"];
    user.Birthday = birthday == nil ? nil : [NSDate dateFromString:birthday withFormat:[NSDate dateFormatString]];
    user.Gender = co.fields[@"Gender"];
    
    user.QPassword = co.fields[@"QPassword"];
    
    user.qbuUser = nil;
}

@end
