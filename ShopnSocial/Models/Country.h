//
//  Country.h
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface Country : NSObject

@property (nonatomic, strong) QBCOCustomObject* customObject;
@property (nonatomic, strong) NSNumber* Code;
@property (nonatomic, strong) NSString* Name;

+(NSArray*)getCountriesSync;//:(void (^)(NSArray *countries))successBlock errorBlock:(void (^)())errorBlock;



@end
