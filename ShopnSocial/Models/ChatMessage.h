//
//  ChatMessage.h
//  ShopnSocial
//
//  Created by rock on 5/27/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Quickblox/Quickblox.h>

@interface ChatMessage : QBChatAbstractMessage<NSCoding, NSCopying>
@property(nonatomic) BOOL read;
+ (instancetype) messageWithChatMessage:(QBChatMessage *)message;
@end
