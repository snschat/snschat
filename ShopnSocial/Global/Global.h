//
//  Global.h
//  ShopnSocial
//
//  Created by rock on 5/5/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

#import "Country.h"
#import "Product.h"
#import "User.h"

#import "ProductCategory.h"
#import "Store.h"
#import "FeaturedStore.h"

#import "ChatService.h"

@interface Global : NSObject

+(Global*) sharedGlobal;

-(void) initUserData;

@property (nonatomic, strong) NSString* LoginedUserEmail;
@property (nonatomic, strong) NSString* LoginedUserPassword;

@property (nonatomic, strong) NSString* HomePage;

@property (nonatomic, strong) NSArray* FavoriteURLs;

#pragma mark -

@property (nonatomic, strong) User* currentUser;

#pragma mark -

-(NSArray*) getFeatureStoreSync;
-(NSArray*) getOfferStoreSync;

#pragma mark -

-(NSArray*) getGoogleSuggestionSync:(NSString*)keyword;

@end
