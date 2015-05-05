//
//  Global.m
//  ShopnSocial
//
//  Created by rock on 5/5/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Global.h"

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


@end
