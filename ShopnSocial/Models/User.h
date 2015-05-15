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
@property (nonatomic, strong) NSNumber* Location;
@property (nonatomic, strong) NSDate* Birthday;
@property (nonatomic, strong) NSString* Gender;

@property (nonatomic, strong) NSString* FacebookID;
@property (nonatomic, strong) NSString* TwitterID;
@property (nonatomic, strong) NSString* GoogleID;


// non-saved field
@property (nonatomic, strong) NSString* Password;

// class methods

+ (User*)getUserByNameSync:(NSString*)username;
+ (User*)getUserByEmailSync:(NSString*)email;
+ (User*)getUserByFacebookSync:(NSString*)fid;
+ (User*)getUserByTwitterSync:(NSString*)tid;
+ (User*)getUserByGooglePlusSync:(NSString*)gid;
+ (BOOL)createNewUserSync:(User*)user;

+ (User*)changePassword:(User*)user oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword;
+ (User*)resetPassword:(User*)user;

+ (User*)currentUser;
+ (void)setCurrentUser:(User*)user;
+ (User*)loginUserSync:(NSString*)email password:(NSString*)password;
+ (QBUUser*)loginQBUUserSync:(NSString*)username password:(NSString*)password;

+ (QBUUser *) getQBUserFromUserSync:(User *) user;
+ (NSArray *) searchUsersByPrefixSync:(NSString *) prefix;

+ (BOOL) setCurrentUserStatusSync:(NSString *) status;

+ (User *) getUserByIDSync:(NSInteger) userID;
+ (NSArray *) getUsersFromContactsSync:(NSArray *) contacts;
// instance methods

- (BOOL) isNeedChangePasswordSync;
- (BOOL) setNeedChangePasswordSync:(BOOL)isNeed;
@end
