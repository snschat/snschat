//
//  Category.h
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface ProductCategory : NSObject

@property (nonatomic, strong) QBCOCustomObject* customObject;

@property (nonatomic, strong) NSString* Name;

@property (nonatomic, readwrite) int LocationCode;

+(NSArray*)getCategoriesSync;

@end
