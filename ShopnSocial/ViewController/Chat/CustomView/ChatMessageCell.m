//
//  ChatMessageCell.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatMessageCell.h"

@implementation ChatMessageCell

- (void)awakeFromNib {
    // Initialization code
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
