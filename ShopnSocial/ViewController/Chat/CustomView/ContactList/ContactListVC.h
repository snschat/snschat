//
//  ContactListVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@protocol ContactListVCDelegate
- (void) onContactSelected:(id) contact;
- (void) onAddContactTouched;
@end

@interface ContactListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, QBChatDelegate>
{
    NSMutableArray * contactList;
}

- (void) setContactListData:(NSArray *) _listData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<ContactListVCDelegate> delegate;
@end
