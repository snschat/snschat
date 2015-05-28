//
//  AddContactVC.h
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *resultMsg;
@property (weak, nonatomic) IBOutlet UIView *searchResult;

@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@property (nonatomic, strong) NSArray * userArr;
@end