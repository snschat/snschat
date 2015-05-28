//
//  AddGroupTableCell.h
//  ShopnSocial
//
//  Created by rock on 5/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

#define STATUS_NONE 0
#define STATUS_ADDED 1

@protocol AddGroupTableCellDelegate<NSObject>
- (BOOL) cellOnAddTouched:(id) tableCell :(id) contact;
- (BOOL) cellOnRemoveTouched:(id) tableCell :(id) contact;

@end

@interface AddGroupTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) id contact;
@property (nonatomic, strong) id<AddGroupTableCellDelegate> delegate;

@property (nonatomic) int cellStatus;

@end
