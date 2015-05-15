//
//  ContactListCell.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ContactListCell.h"
#import "ExUILabel+AutoSize.h"

@implementation ContactListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //Set circular image view.
    CGRect frame = self.avatarImgView.frame;
    self.avatarImgView.layer.cornerRadius = frame.size.width / 2;
    self.avatarImgView.layer.masksToBounds = YES;
    self.annotView.hidden = YES;
    self.badge.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    if(selected)
        self.m_backImg.hidden = NO;
    else
        self.m_backImg.hidden = YES;
    // Configure the view for the selected state
    
}
- (void) setBadgeNumber:(NSInteger) badgeNum
{
    self.badge.text = [NSString stringWithFormat:@"%i", badgeNum];
    CGRect frame = self.badge.frame;
 
    frame.size.width = [self.badge expectedHeight];
    self.badge.frame = frame;
    [self.badge sizeToFit];
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
        self.accept.hidden = YES;
        self.decline.hidden = YES;
        self.badge.hidden = YES;
        self.annotView.hidden = NO;
    }

    CGPoint endPoint = CGPointMake(self.frame.size.width, 0);
    CGFloat estimated_width = 0;
    CGFloat paddingX = 10;
    for(NSNumber * num in annotArray)
    {
        switch ([num integerValue]) {
            case ANNOT_AWAITING:
            {
                self.awaitingLabel.hidden = NO;
                CGRect frame = self.awaitingLabel.frame;
                frame.origin.x = estimated_width;
                self.awaitingLabel.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case ANNOT_BADGE:
            {
                self.badge.hidden = NO;
                CGRect frame = self.badge.frame;
                frame.origin.x = estimated_width;
                self.badge.frame = frame;
                estimated_width += frame.size.width + paddingX;
            }
                break;
            case ANNOT_CALL:
            {
            }
                break;
            case ANNOT_CONFIRM:
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


@end
