//
//  Global.m
//  ShopnSocial
//
//  Created by rock on 5/5/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Global.h"
#import "FBEncryptorAES.h"

static Global* gShared = nil;

@interface Global ()

@property (nonatomic, strong) NSUserDefaults* store;

@end

@implementation Global

@synthesize store;

+(Global*) sharedGlobal
{
    if (gShared != nil) return gShared;
    
    gShared = [[Global alloc] init];
    gShared.store = [NSUserDefaults standardUserDefaults];
    
    return gShared;
}

-(NSString*) LoginedUserEmail
{
    NSString* result = [store stringForKey:@"LoginedUserEmail"];
    return result;
}

-(void) setLoginedUserEmail:(NSString *)LogginedUserEmail
{
    [store setObject:LogginedUserEmail forKey:@"LoginedUserEmail"];
    [store synchronize];
}

-(NSString*) LoginedUserPassword
{
    NSString* result = [store stringForKey:@"LoginedUserPassword"];
    result = [FBEncryptorAES decryptBase64String:result keyString:AesStoreKey];
    return result;
}

-(void) setLoginedUserPassword:(NSString *)LoginedUserPassword
{
    LoginedUserPassword = [FBEncryptorAES encryptBase64String:LoginedUserPassword keyString:AesStoreKey separateLines:NO];
    [store setObject:LoginedUserPassword forKey:@"LoginedUserPassword"];
    [store synchronize];
}


@end
