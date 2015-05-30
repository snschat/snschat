//
//  GroupContactCell.h
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GROUPCELL_ANNOT_ADD 1
#define GROUPCELL_ANNOT_REMOVE 2
#define GROUPCELL_ANNOT_AWAITING 3

@protocol GroupContactCellDelegate<NSObject>
- (void) onGroupAddContactTouched;
- (void) onGroupRemoveContactTouched;
@end

@interface GroupContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactStatus;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;


// Accessory controls
@property (weak, nonatomic) IBOutlet UILabel *awaitingLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIView *annotView;

@property (nonatomic, strong) id<GroupContactCellDelegate> delegate;

- (void) setAnnotations:(NSArray *) annotArray;
@end
