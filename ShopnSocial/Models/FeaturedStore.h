//
//  Category.h
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface FeaturedStore : NSObject

@property (nonatomic, strong) QBCOCustomObject* customObject;

-(NSString*) Name;

-(NSString*) ImageURL;

-(NSString*) AffiliateURL;

-(int) LocationCode;

+(NSArray*)getStoresWithTypeSync:(NSString*)type inCountry:(int)locationCode;

@end
