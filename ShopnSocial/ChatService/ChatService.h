//
//  Chat.h
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat : NSObject
+ (void) loginToChat;
+ (void) logout;
+ (BOOL) isLoggedIn;
@end
