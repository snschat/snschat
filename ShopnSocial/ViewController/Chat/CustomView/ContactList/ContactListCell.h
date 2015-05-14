//
//  ContactListCell.h
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIView *annotView;
@property (weak, nonatomic) IBOutlet UIImageView *m_backImg;

@end
