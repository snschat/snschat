//
//  ChatMessageCell.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatMessageCell.h"
#import "ChatService.h"

@implementation ChatMessageCell

- (void)awakeFromNib {
    // Initialization code
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = true;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void) configureCellWithMessage:(QBChatMessage *) message
{
    QBUUser * qbUser = [[ChatService shared].usersAsDictionary objectForKey: @(message.senderID)];
    
    if(message.senderID == [User currentUser].qbuUser.ID)
    {
        self.nameText.text = @"Me:";
    }
    else
    {
        self.nameText.text = [NSString stringWithFormat:@"%@:" , qbUser.fullName];
    }
    self.messageText.text = message.text;

    if([message isKindOfClass:[QBChatHistoryMessage class]])
    {
        QBChatHistoryMessage * hMsg = (QBChatHistoryMessage *)message;
        if(hMsg.read)
            self.statusText.hidden = YES;
        else
            self.statusText.hidden = NO;
    }
    
    [self.nameText sizeThatFits:CGSizeMake(64.0, FLT_MAX)];
    [self.messageText sizeThatFits: CGSizeMake(420, FLT_MAX)];
}

@end
