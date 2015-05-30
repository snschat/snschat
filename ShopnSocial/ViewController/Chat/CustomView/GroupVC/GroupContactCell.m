//
//  GroupContactCell.m
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "GroupContactCell.h"
@interface GroupContactCell()
{
    UIColor * orgAddColor;
    UIColor * orgRemoveColor;
}
@end

@implementation GroupContactCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    CGRect frame = self.avatarImg.frame;
    self.avatarImg.layer.cornerRadius = frame.size.width / 2;
    self.avatarImg.layer.masksToBounds = YES;
    self.annotView.hidden = YES;
    
    //Save original color of labels and buttons since they are cleared when the cell is selected
    orgAddColor = self.addBtn.backgroundColor;
    orgRemoveColor = self.removeBtn.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onAddBtnTouched:(id)sender {
    if([self.delegate respondsToSelector:@selector(onGroupAddContactTouched)])
    {
        [self.delegate onGroupAddContactTouched];
    }
}
- (IBAction)onRemoveBtnTouched:(id)sender {
    if([self.delegate respondsToSelector:@selector(onGroupRemoveContactTouched)])
    {
        [self.delegate onGroupRemoveContactTouched];
    }
}
- (void) setAnnotations:(NSArray *) annotArray
{
    
    if(annotArray.count == 0)
    {
        self.annotView.hidden = YES;
        return;
    }
    else{
        self.awaitingLabel.hidden = YES;
        self.annotView.hidden = NO;
    }
    
    CGPoint endPoint = CGPointMake(self.frame.size.width, 0);
    CGFloat estimated_width = 0;
    CGFloat paddingX = 20;
    for(NSNumber * num in annotArray)
    {
        switch ([num integerValue]) {
            case GROUPCELL_ANNOT_AWAITING:
            {
                self.awaitingLabel.hidden = NO;
                CGRect frame = self.awaitingLabel.frame;
                frame.origin.x = estimated_width;
                self.awaitingLabel.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case GROUPCELL_ANNOT_ADD:
            {
                self.addBtn.hidden = NO;
                CGRect frame = self.addBtn.frame;
                frame.origin.x = estimated_width;
                self.addBtn.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case GROUPCELL_ANNOT_REMOVE:
            {
                self.removeBtn.hidden = NO;
                CGRect frame = self.removeBtn.frame;
                frame.origin.x = estimated_width;
                self.removeBtn.frame = frame;
                estimated_width += frame.size.width + paddingX;

            }
                break;
            default:
                break;
        }
    }
    self.annotView.frame = CGRectMake(endPoint.x - estimated_width, endPoint.y, estimated_width, self.frame.size.height);
}

@end
