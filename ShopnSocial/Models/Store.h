//
//  Category.h
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

#include "ProductCategory.h"

@interface Store : NSObject

@property (nonatomic, strong) QBCOCustomObject* customObject;

-(NSString*) Retailer;

-(NSString*) LogoURL;

-(NSString*) Description;

-(NSString*) SiteURL;

-(NSString*) AffiliateURL;

-(BOOL) IsQuickLink;

+(NSArray*)getStoresInCategorySync:(ProductCategory*)cateogry;

+(NSArray*)getQuickStoresInLocationSync:(int)locationCode;


@end
