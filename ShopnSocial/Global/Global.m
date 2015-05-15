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

#pragma mark -

-(void) initUserData
{
    User * user = [self currentUser];
    
    //Login to chat service
    [[ChatService shared] loginWithUser:user.qbuUser completionBlock:nil];

    
    [ProductCategory getCategoriesSync];
    
    [self getFeatureStoreSync];
    [self getOfferStoreSync];
}

#pragma mark -

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

-(User*)currentUser
{
    return [User currentUser];
}

-(void)setCurrentUser:(User *)user
{
    [User setCurrentUser:user];
}

#pragma mark -

-(NSArray*) getFeatureStoreSync
{
    static NSArray* featureStore = nil;
    
    if (featureStore == nil)
    {
        featureStore = [FeaturedStore getStoresWithTypeSync:@"F" inCountry:[self currentUser].Location.intValue];
    }
    
    return featureStore;
}

-(NSArray*) getOfferStoreSync
{
    static NSArray* offerStore = nil;
    
    if (offerStore == nil)
    {
        offerStore = [FeaturedStore getStoresWithTypeSync:@"O" inCountry:[self currentUser].Location.intValue];
    }
    
    return offerStore;
}

#pragma mark -

-(NSArray*) getGoogleSuggestionSync:(NSString*)searchText
{
    searchText = [NSString stringWithFormat:@"%@", searchText];
    
    NSString* keyword = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    keyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block NSArray* suggetions = nil;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GoogleSuggestionURL, keyword]]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError * err;
        suggetions =[[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments |NSJSONReadingMutableLeaves error:&err]];

        if (suggetions != nil) {
            if (suggetions.count > 1) {
                suggetions = [suggetions objectAtIndex:1];
            }
        }
        
        dispatch_semaphore_signal(sema);
    }];
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (suggetions == nil || suggetions.count == 0) return nil;
    
    return @[searchText, suggetions];
}

@end
