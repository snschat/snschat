//
//  GroupContact.h
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import "User.h"

#define GROUPCONTACT_ADDED 1
#define GROUPCONTACT_AWAITING 2
#define GROUPCONTACT_AVAILABLE 3
@interface GroupContact : NSObject
@property(nonatomic, strong) User * user;
@property(nonatomic) NSInteger contactStatus;
@end
