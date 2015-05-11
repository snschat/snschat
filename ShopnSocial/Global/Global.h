//
//  Global.h
//  ShopnSocial
//
//  Created by rock on 5/5/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface Global : NSObject

+(Global*) sharedGlobal;

@property (nonatomic, strong) NSString* LoginedUserEmail;
@property (nonatomic, strong) NSString* LoginedUserPassword;

@end
