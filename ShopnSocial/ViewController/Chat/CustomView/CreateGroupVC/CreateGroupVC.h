//
//  CreateGroupVC.h
//  ShopnSocial
//
//  Created by rock on 5/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGroupTableCell.h"
#import "ChatService.h"

@interface CreateGroupVC : UIViewController<UITableViewDataSource, UITableViewDelegate, AddGroupTableCellDelegate, ChatServiceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTxt;
@property (weak, nonatomic) IBOutlet UIButton *createGroupBtn;
@property (weak, nonatomic) IBOutlet UIView *topbar;

@property (nonatomic, strong) NSArray * contacts;
- (BOOL) isAvailableCreate;
@end
