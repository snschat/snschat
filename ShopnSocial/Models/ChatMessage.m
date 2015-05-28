//
//  ChatMessage.m
//  ShopnSocial
//
//  Created by rock on 5/27/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage
+ (instancetype) messageWithChatMessage:(QBChatMessage *)message
{
    return [[ChatMessage alloc] initWithChatMessage: message];
}
- (id) initWithChatMessage:(QBChatMessage *)message{
    if(self = [super init])
    {
        self.ID = message.ID;
        self.text = message.text;
        self.recipientID = message.recipientID;
        self.senderID = message.senderID;
        self.datetime = message.datetime;
        self.customParameters = message.customParameters;
        self.attachments = message.attachments;
        self.read = NO;
    }
    return self;
}
@end
