//
//  ChatMessageCell.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatMessageCell.h"
#import "ChatService.h"
#import "ChatMessage.h"

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
- (void) configureCellWithMessage:(id) message
{
    QBChatAbstractMessage * msg = message;
    QBUUser * qbUser = [[ChatService shared].usersAsDictionary objectForKey: @(msg.senderID)];
    
    if(msg.senderID == [ChatService shared].currentUser.ID)
    {
        self.nameText.text = @"Me:";
    }
    else if(qbUser == nil)
    {
        self.nameText.text = @"";
    }
    else{
        self.nameText.text = qbUser.fullName;
    }
    self.messageText.text = msg.text;
    self.statusText.hidden = YES;
    if([message isKindOfClass:[QBChatHistoryMessage class]])
    {
        QBChatHistoryMessage * hMsg = (QBChatHistoryMessage *)message;
        
        if([hMsg isRead])
            self.statusText.hidden = YES;
        else if(hMsg.senderID == [ChatService shared].currentUser.ID)
            self.statusText.hidden = NO;
    }
    else if([message isKindOfClass: [ChatMessage class]])
    {
        if([message read])
            self.statusText.hidden = YES;
        else
            self.statusText.hidden = NO;
    }
    
    [self.nameText sizeThatFits:CGSizeMake(64.0, FLT_MAX)];
    [self.messageText sizeThatFits: CGSizeMake(420, FLT_MAX)];
}

@end
