//
//  ContactListVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "ChatService.h"
#import "ContactListCell.h"

@protocol ContactListVCDelegate
- (void) onContactSelected:(id) contact;
- (void) onAddContactTouched;
@end

@interface ContactListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, ChatServiceDelegate, ContactListCellDelegate>
{
    NSMutableArray * contactList;
    
    NSMutableArray * availableList;
    NSMutableArray * waitingList;
}

- (void) setContactListData:(NSArray *) _listData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<ContactListVCDelegate> delegate;
@end
