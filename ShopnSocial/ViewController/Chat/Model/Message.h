//
//  Message.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic, strong) NSString * senderName;
@property(nonatomic, strong) NSString * senderId;
@property(nonatomic, strong) NSString * message;
@property(nonatomic, strong) NSString * status;
@end
