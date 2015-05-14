//
//  AddFavouriteCell.h
//  ShopnSocial
//
//  Created by rock on 5/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFavouriteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UIView *resultMsgView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
- (void) showAddView;
- (void) showResultMsg;
- (BOOL) isAddViewVisible;
@end
