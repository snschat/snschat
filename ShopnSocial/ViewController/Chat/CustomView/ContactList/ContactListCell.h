//
//  ContactListCell.h
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ANNOT_AWAITING 0
#define ANNOT_CONFIRM 1
#define ANNOT_BADGE 2
#define ANNOT_CALL 3

@protocol ContactListCellDelegate<NSObject>
- (void) onAcceptTouched:(id) cell;
- (void) onDeclineTouched:(id) cell;
@end

@interface ContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *annotView;
@property (weak, nonatomic) IBOutlet UIImageView *m_backImg;


//Premade controls
@property (weak, nonatomic) IBOutlet UILabel *awaitingLabel;
@property (weak, nonatomic) IBOutlet UIButton *accept;
@property (weak, nonatomic) IBOutlet UIButton *decline;
@property (weak, nonatomic) IBOutlet UILabel *badge;

@property (weak, nonatomic) id<ContactListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indexPath;
- (void) setBadgeNumber:(NSInteger) badgeNum;
- (void) setAnnotations:(NSArray *) annotArray;
@end
