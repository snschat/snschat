//
//  GroupVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupVC : UIViewController<UITableViewDelegate , UITableViewDataSource>
{
    NSMutableArray * groupListData;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void) setGroupListData:(NSArray *) _listData;

@end
