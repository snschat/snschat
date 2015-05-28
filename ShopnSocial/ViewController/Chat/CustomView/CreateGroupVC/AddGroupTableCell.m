//
//  AddGroupTableCell.m
//  ShopnSocial
//
//  Created by rock on 5/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddGroupTableCell.h"

@implementation AddGroupTableCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImg.layer.cornerRadius = 17.0f;
    self.avatarImg.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onRemoveBtnTouched:(id)sender {
    if([self.delegate respondsToSelector:@selector( cellOnAddTouched::)])
    {
        if([self.delegate cellOnRemoveTouched:self :self.contact]) //If processed
        {
            [self setCellStatus: NO];
        }
    }
}
- (IBAction)onAddBtnTouched:(id)sender {
    if([self.delegate respondsToSelector:@selector(cellOnAddTouched::)])
    {
        if([self.delegate cellOnAddTouched:self :self.contact])  //If processed
        {
            [self setCellStatus: YES];
        }
            
    }
}

- (void) setCellStatus:(int)cellStatus
{
    if(cellStatus == STATUS_NONE)
    {
        self.addBtn.hidden = NO;
        self.removeBtn.hidden = YES;
    }
    else if(cellStatus == STATUS_ADDED)
    {
        self.addBtn.hidden = YES;
        self.removeBtn.hidden = NO;
    }
    _cellStatus = cellStatus;
}

- (void) setContact:(id)obj
{
    _contact = obj;
    Contact * contact  = obj;
    self.avatarImg = nil;
    self.userName.text = contact.user.Username;
    self.userStatus.text = contact.user.Status;

}
@end
