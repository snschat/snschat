//
//  GroupVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GroupVCDelegate
- (void) onGroupSelected:(id) group;
@end

@interface GroupVC : UIViewController<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray * groupListData;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<GroupVCDelegate> delegate;

- (void) setGroupListData:(NSArray *) _listData;

@end
