//
//  BrowserHomeVC.h
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnsPageView.h"

@interface BrowserHomeVC : UIViewController <UITextFieldDelegate, SnsPageDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray* searchedProdcuts;
}

@property (strong, nonatomic) IBOutlet UIView *topBar;

@property (strong, nonatomic) IBOutlet UIView *chatbar;
@property (strong, nonatomic) IBOutlet UIButton *buttonChatSlider;

// navigation bar
@property (strong, nonatomic) IBOutlet UIButton *btnNavBack;
@property (strong, nonatomic) IBOutlet UIButton *btnNavForward;
@property (strong, nonatomic) IBOutlet UIButton *btnNavFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnNavHome;
@property (strong, nonatomic) IBOutlet UIButton *btnNavNewTab;


@property (strong, nonatomic) IBOutlet UIScrollView *layTabbar;

@property (strong, nonatomic) IBOutlet UIView *mainview;

// search product
@property (strong, nonatomic) IBOutlet UIView *laySearch;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
- (IBAction)onSearchGoogle;

////
@end
