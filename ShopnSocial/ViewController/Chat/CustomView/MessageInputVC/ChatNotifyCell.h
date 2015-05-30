//
//  ChatNotifyCell.h
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatNotifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void) configureCellWithMessage:(id) message;
- (CGFloat) expectedHeight:(CGFloat) cellWidth;
+ (CGFloat) expectedHeight:(CGFloat) cellWidth :(NSString *) text;
@end
