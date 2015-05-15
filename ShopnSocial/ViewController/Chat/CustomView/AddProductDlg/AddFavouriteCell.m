//
//  AddFavouriteCell.m
//  ShopnSocial
//
//  Created by rock on 5/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddFavouriteCell.h"

@implementation AddFavouriteCell

- (void)awakeFromNib {
    // Initialization code
    [self showAddView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) showAddView
{
    self.addView.hidden = NO;
    self.resultMsgView.hidden = YES;
}
- (void) showResultMsg
{
    self.addView.hidden = YES;
    self.resultMsgView.hidden = NO;
}
- (BOOL) isAddViewVisible
{
    return !self.addView.hidden;
}
@end
