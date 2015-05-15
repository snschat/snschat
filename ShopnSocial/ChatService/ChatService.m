//
//  Chat.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Chat.h"
#import "User.h"

#import <Quickblox/Quickblox.h>
@implementation Chat
+ (void) loginToChat
{
    QBUUser * qbUser = [User currentUser].qbuUser;
    NSInteger uid = qbUser.ID;
    [[QBChat instance] loginWithUser: qbUser];
}
+ (void) logout
{
    [[QBChat instance] logout];
}
+ (BOOL) isLoggedIn
{
    return [[QBChat instance] isLoggedIn];
}
@end
