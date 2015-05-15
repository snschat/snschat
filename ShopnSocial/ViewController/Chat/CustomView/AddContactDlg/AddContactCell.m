//
//  AddContactCell.m
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddContactCell.h"

@implementation AddContactCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImg.layer.masksToBounds = YES;
    self.avatarImg.layer.cornerRadius = 22;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
