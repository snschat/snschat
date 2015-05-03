//
//  User.h
//  ShopnSocial
//
//  Created by rock on 5/2/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface User : NSObject

@property (nonatomic, strong) QBCOCustomObject* customObject;
@property (nonatomic, strong) QBUUser* qbuUser;

@property (nonatomic, strong) NSString* Username;
@property (nonatomic, strong) NSString* Email;
@property (nonatomic, strong) NSString* Password;
@property (nonatomic, strong) NSNumber* Location;
@property (nonatomic, strong) NSDate* Birthday;
@property (nonatomic, strong) NSString* Gender;

@property (nonatomic, strong) NSString* QPassword;


+ (User*)getUserByNameSync:(NSString*)username;
+ (User*)getUserByEmailSync:(NSString*)email;
+ (BOOL)createNewUserSync:(User*)user;

+ (User*)currentUser;
+ (void)setCurrentUser:(User*)user;
+ (User*)loginUserSync:(NSString*)email password:(NSString*)password;
+ (QBUUser*)loginQBUUserSync:(NSString*)username password:(NSString*)password;

@end
