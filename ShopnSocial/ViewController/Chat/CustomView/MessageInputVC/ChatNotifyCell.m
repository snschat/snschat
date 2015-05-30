//
//  ChatNotifyCell.m
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatNotifyCell.h"
#import "ExUIView+Border.h"
#import "ExUILabel+AutoSize.h"

#import <Quickblox/Quickblox.h>

@implementation ChatNotifyCell

- (void)awakeFromNib {
    // Initialization code
    //Add border to container view and make the corner round
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius  = 5;
    [self.containerView border:1.0f color:[UIColor blackColor]];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void) configureCellWithMessage:(id) message
{
    if([message isKindOfClass: [QBChatAbstractMessage class]])
    {
        QBChatAbstractMessage * msg = message;
        self.cellText.text = msg.text;
    }
    else if([message isKindOfClass: [NSString class]])
    {
        self.cellText.text = message;
    }
}
+ (CGFloat) expectedHeight:(CGFloat) cellWidth :(NSString *) text
{
    UIFont * font = [UIFont systemFontOfSize: 17];
    CGFloat margin = 88;
    CGFloat containerWidth = cellWidth - margin;
    
    if(containerWidth < 0)
        containerWidth = 0;
    return [UILabel expectedHeight:containerWidth :font :text] + 50;
    
}
- (CGFloat) expectedHeight:(CGFloat) cellWidth
{
    CGFloat margin = 88;
    CGFloat containerWidth = cellWidth - margin;
    
    if(containerWidth < 0)
        containerWidth = 0;
    return [UILabel expectedHeight:containerWidth :self.cellText.font :self.cellText.text] + 50;
}
@end
