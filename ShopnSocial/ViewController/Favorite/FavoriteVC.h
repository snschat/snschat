//
//  ChatVC.h
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTabBar.h"
#import "ContactListVC.h"
#import "GroupVC.h"

@interface FavoriteVC : UIViewController<ContactTabBarDelegate, ContactListVCDelegate, GroupVCDelegate>

//Background Image
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (weak, nonatomic) IBOutlet UIView *mainBoard;
@property (weak, nonatomic) IBOutlet UIView *messageBoard;
@property (weak, nonatomic) IBOutlet UIView *sharedBoard;

- (void) prepareBackgroundImage:(UIView *)underView;
@end
