//
//  ContactListCell.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ContactListCell.h"
#import "ExUILabel+AutoSize.h"
@interface ContactListCell()
{
    UIColor * orgBadgeColor;
    UIColor * orgAcceptColor;
    UIColor * orgDeclineColor;
    
    BOOL bCellDeclined;
}
@end
@implementation ContactListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //Set circular image view.
    CGRect frame = self.avatarImgView.frame;
    self.avatarImgView.layer.cornerRadius = frame.size.width / 2;
    self.avatarImgView.layer.masksToBounds = YES;
    self.annotView.hidden = YES;
    
    self.badge.layer.cornerRadius = 5;
    self.badge.layer.masksToBounds = YES;
    
    //Save original color of labels and buttons since they are cleared when the cell is selected
    orgAcceptColor = self.accept.backgroundColor;
    orgDeclineColor = self.decline.backgroundColor;
    orgBadgeColor = self.badge.backgroundColor;
    
    [self setCellDeclined: FALSE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if(bCellDeclined)
        return;
    
    if(selected)
    {
        self.m_backImg.hidden = NO;
        
        self.accept.backgroundColor = orgAcceptColor;
        self.decline.backgroundColor = orgDeclineColor;
        self.badge.backgroundColor = orgBadgeColor;
    }
    else
    {
        self.m_backImg.hidden = YES;
    }
    // Configure the view for the selected state
    
}
- (void) setBadgeNumber:(NSInteger) badgeNum
{
    self.badge.text = [NSString stringWithFormat:@"%i", badgeNum];
    CGRect frame = self.badge.frame;
 
    frame.size.width = [self.badge expectedWidth] + 8;
    self.badge.frame = frame;
}

- (void) setAnnotations:(NSArray *) annotArray
{
    if(bCellDeclined)
        return;
    
    if(annotArray.count == 0)
    {
        self.annotView.hidden = YES;
        return;
    }
    else{
        self.awaitingLabel.hidden = YES;
        self.accept.hidden = YES;
        self.decline.hidden = YES;
        self.badge.hidden = YES;
        self.annotView.hidden = NO;
    }

    CGPoint endPoint = CGPointMake(self.frame.size.width, 0);
    CGFloat estimated_width = 0;
    CGFloat paddingX = 20;
    for(NSNumber * num in annotArray)
    {
        switch ([num integerValue]) {
            case CONTACT_ANNOT_AWAITING:
            {
                self.awaitingLabel.hidden = NO;
                CGRect frame = self.awaitingLabel.frame;
                frame.origin.x = estimated_width;
                self.awaitingLabel.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case CONTACT_ANNOT_BADGE:
            {
                self.badge.hidden = NO;
                CGRect frame = self.badge.frame;
                frame.origin.x = estimated_width;
                self.badge.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case CONTACT_ANNOT_CALL:
            {
            }
                break;
            case CONTACT_ANNOT_CONFIRM:
            {
                self.accept.hidden = NO;
                self.decline.hidden = NO;
                CGRect frame = self.accept.frame;
                frame.origin.x = estimated_width;
                self.accept.frame = frame;
                
                estimated_width += frame.size.width + paddingX;
                
                frame = self.decline.frame;
                frame.origin.x = estimated_width;
                self.decline.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            default:
                break;
        }
    }
    self.annotView.frame = CGRectMake(endPoint.x - estimated_width, endPoint.y, estimated_width, self.frame.size.height);
}

- (IBAction)onAcceptTouched:(id)sender {
    [self.delegate onAcceptTouched: self];
}

- (IBAction)onDeclineTouched:(id)sender {
    [self.delegate onDeclineTouched: self];
}

- (void) setCellDeclined:(BOOL) bDeclined
{
    if(!bDeclined)
    {
        [self.annotView setHidden:NO];
        self.backgroundColor = [UIColor clearColor];
        self.declineLabel.hidden = YES;
    }
    else
    {
        [self.annotView setHidden: YES];
        self.backgroundColor = [UIColor colorWithRed:0.93f green:0.04f blue:0.04f alpha:0.15f];
        self.declineLabel.hidden = NO;
    }
    
    bCellDeclined = bDeclined;
}

- (IBAction)onLongPressContentView:(id)sender {
    [self.delegate onLongPressCell: self];
}

@end
