//
//  Contact.h
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Contact : NSObject
@property(nonatomic, strong) User * user;
@property (nonatomic) BOOL bWaiting;
@property (nonatomic) BOOL bPending;
@end
