//
//  ContactListCell.h
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CONTACT_ANNOT_AWAITING 0
#define CONTACT_ANNOT_CONFIRM 1
#define CONTACT_ANNOT_BADGE 2
#define CONTACT_ANNOT_CALL 3

@protocol ContactListCellDelegate<NSObject>
- (void) onAcceptTouched:(id) cell;
- (void) onDeclineTouched:(id) cell;
- (void) onLongPressCell:(id) cell;
@end

@interface ContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *annotView;
@property (weak, nonatomic) IBOutlet UIImageView *m_backImg;

@property (weak, nonatomic) IBOutlet UILabel *declineLabel;

//Premade controls
@property (weak, nonatomic) IBOutlet UILabel *awaitingLabel;
@property (weak, nonatomic) IBOutlet UIButton *accept;
@property (weak, nonatomic) IBOutlet UIButton *decline;
@property (weak, nonatomic) IBOutlet UILabel *badge;

@property (weak, nonatomic) id<ContactListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indexPath;
- (void) setBadgeNumber:(NSInteger) badgeNum;
- (void) setAnnotations:(NSArray *) annotArray;
- (void) setCellDeclined:(BOOL) bDeclined;
@end
