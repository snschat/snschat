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

@interface ChatVC : UIViewController<ContactTabBarDelegate, ContactListVCDelegate, GroupVCDelegate>

//TapBar control
@property (weak, nonatomic) IBOutlet UIView *m_tabbarContainer;
@property (weak, nonatomic) IBOutlet UIView *m_tabview;

//Profile control
@property (weak, nonatomic) IBOutlet UIImageView *m_profileImg;
@property (weak, nonatomic) IBOutlet UILabel *m_profileName;
@property (weak, nonatomic) IBOutlet UILabel *m_profileStatus;

//Background Image
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

//Contact User
@property (weak, nonatomic) IBOutlet UIImageView *contactImg;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactStatus;

@property (weak, nonatomic) IBOutlet UIView *mainBoard;
@property (weak, nonatomic) IBOutlet UIView *messageBoard;
@property (weak, nonatomic) IBOutlet UIView *sharedBoard;

- (void) prepareBackgroundImage:(UIView *)underView;
@end
