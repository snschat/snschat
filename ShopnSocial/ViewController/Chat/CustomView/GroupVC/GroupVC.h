//
//  GroupVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListCell.h"
#import "ChatService.h"

@protocol GroupVCDelegate<NSObject>
- (void) onGroupSelected:(id) group;
- (void) showCreateGroup;
@end

@interface GroupVC : UIViewController<UITableViewDelegate , UITableViewDataSource, ContactListCellDelegate, ChatServiceDelegate>
{
    NSMutableArray * groupListData;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<GroupVCDelegate> delegate;

- (void) setGroupListData:(NSArray *) _listData;

@end
