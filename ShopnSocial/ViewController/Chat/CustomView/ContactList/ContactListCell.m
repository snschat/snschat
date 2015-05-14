//
//  ContactListCell.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //Set circular image view.
    CGRect frame = self.avatarImgView.frame;
    self.avatarImgView.layer.cornerRadius = frame.size.width / 2;
    self.avatarImgView.layer.masksToBounds = YES;
    self.m_backImg.image = [UIImage imageNamed: @"cell_selected_back"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    if(selected)
        self.m_backImg.hidden = NO;
    else
        self.m_backImg.hidden = YES;
    // Configure the view for the selected state
    
}
- (void) setAnnotations:(NSArray *) annotArray
{
   
}
@end
