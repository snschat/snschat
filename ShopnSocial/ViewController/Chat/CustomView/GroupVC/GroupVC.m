//
//  GroupVC.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "GroupVC.h"
#import "ContactListCell.h"
#import "ChatService.h"
#import "UIImageView+WebCache.h"
#import "ExQBChatDialog.h"

#import "GroupContact.h"
#import "GroupContactCell.h"

@interface GroupVC ()

@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib* nib = [UINib nibWithNibName: @"ContactListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"contact_list_cell"];
    
    nib = [UINib nibWithNibName: @"GroupContactCell" bundle: [NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"group_contact_cell"];
    
    //Table View separator setting
    [self.tableView setSeparatorColor: [UIColor whiteColor]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
    
    [self setGroupListData: [ChatService shared].dialogs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[ChatService shared] addDelegate: self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[ChatService shared] removeDelegate: self];
}

- (IBAction)onAddGroupTouched:(id)sender {
    if([self.delegate respondsToSelector: @selector(showCreateGroup)])
    {
        [self.delegate showCreateGroup];
    }
}

- (void) setGroupListData:(NSArray *) _listData
{
    NSMutableArray * temp = [NSMutableArray array];
    for(QBChatDialog * dialog in _listData)
    {
        if(dialog.type == QBChatDialogTypeGroup)
        {
            [temp addObject: dialog];
        }
    }
    groupListData = temp;
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [groupListData objectAtIndex: indexPath.row];
    if([obj isKindOfClass: [QBChatDialog class]])
    {
        ContactListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contact_list_cell"];
        
        cell.backgroundColor = [UIColor clearColor];
        
        QBChatDialog* dlgInfo = [groupListData objectAtIndex: indexPath.row];
        
        //TODO: Populate data
        cell.contactName.text = dlgInfo.name;
        
        //TODO : status info for chat dialog.
        cell.status.text = @"";
        
        //TODO : load avatar image from QuickBlox
        [cell.avatarImgView setImageWithURL:[NSURL URLWithString: dlgInfo.photo] placeholderImage: [UIImage imageNamed: @"avatar_s1"]];
        cell.indexPath = indexPath;
        [cell setCellDeclined: FALSE];
        
        if(![dlgInfo isAccepted: [User currentUser].qbuUser])
        {
            cell.delegate = self;
            [cell setAnnotations: @[@(CONTACT_ANNOT_CONFIRM)]];
        }
        else
        {
            [cell setAnnotations: @[]];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;

    }
    else if([obj isKindOfClass: [GroupContact class]])
    {
        GroupContactCell * cell = [tableView dequeueReusableCellWithIdentifier: @"group_contact_cell"];
        cell.backgroundColor = [UIColor clearColor];
        
        GroupContact * contact = [groupListData objectAtIndex: indexPath.row];
        
        cell.contactLabel.text = contact.user.Username;
        cell.contactStatus.text = contact.user.Status;
        
        if(contact.contactStatus == GROUPCONTACT_ADDED)
        {
            [cell setAnnotations: @[@(GROUPCELL_ANNOT_REMOVE)]];
        }
        else if(contact.contactStatus == GROUPCONTACT_AVAILABLE)
        {
            [cell setAnnotations: @[@(GROUPCELL_ANNOT_ADD)]];
        }
        else if(contact.contactStatus == GROUPCONTACT_AWAITING){
            [cell setAnnotations: @[@(GROUPCELL_ANNOT_AWAITING)]];
        }
        cell.delegate = self;
        //TODO: load avatar image here.
//        cell.avatarImg.image =
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"default"];
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: indexPath.row];

    if([dlgInfo isAccepted: [User currentUser].qbuUser] )
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
        return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //TODO: Delete group
        QBChatDialog * dlgInfo = [groupListData objectAtIndex: indexPath.row];
        
        [[ChatService shared] leaveGroupDialog:dlgInfo :[User currentUser].UserID completionBlock:^(QBResponse * response, QBChatDialog * dialog) {
            [self reloadDialogs];
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        id data = [groupListData objectAtIndex: indexPath.row];
        [self.delegate onGroupSelected: data];
    }
}
#pragma mark ContactListCellDelegate
- (void) onAcceptTouched:(id) obj
{
    ContactListCell * cell = obj;
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: cell.indexPath.row];
    
    //Send notification to users
    QBChatMessage * msg = [[ChatService shared] createChatNotificationForGroupChat: dlgInfo];
    msg.text = [NSString stringWithFormat: @"%@ has joined the group", [User currentUser].Username];
    msg.customParameters[@"notification_type"] = NOTIFY_GROUP_CHAT_JOIN;
    msg.customParameters[@"user_id"] = @([ChatService shared].currentUser.ID);
    msg.customParameters[@"save_to_history"] = @YES;
    
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithDictionary:dlgInfo.data];
    
    NSMutableArray *accepted_users = [NSMutableArray array];
    
    if(![dlgInfo.data[@"accepted_users"] isEqual: [NSNull null]])
        accepted_users = [NSMutableArray arrayWithArray: dlgInfo.data[@"accepted_users"]];
    
    [accepted_users addObject: @([User currentUser].UserID)];
    
    [dictionary setValue:@"GroupData" forKey:@"class_name"];
    [dictionary setValue: accepted_users forKey:@"accepted_users"];
    dlgInfo.data = dictionary;
    
    //Send join message.
    [[ChatService shared] joinRoom:[dlgInfo chatRoom] completionBlock:^(QBChatRoom * chatRoom) {
        [[ChatService shared] sendMessage:msg toRoom: chatRoom];
        [[ChatService shared] leaveRoom: chatRoom];
    }];
    
    //Update dialog
    [QBRequest updateDialog:dlgInfo successBlock:^(QBResponse * response, QBChatDialog *dialog) {
        [[ChatService shared] requestDialogsWithCompletionBlock:^{
            [self setGroupListData: [ChatService shared].dialogs];
        }];
    } errorBlock:^(QBResponse *response) {
        
    }];

}

- (void) onDeclineTouched:(id) obj
{
    ContactListCell * cell = obj;
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: cell.indexPath.row];
    
    //TODO : delete user from dialog
    [[ChatService shared] leaveGroupDialog:dlgInfo :[User currentUser].UserID completionBlock:^(QBResponse * response, QBChatDialog * dialog) {

        [groupListData removeObject: dlgInfo];
        [self.tableView reloadData];
    }];

}
- (void) onLongPressCell:(id) obj
{
    ContactListCell * cell = obj;
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: cell.indexPath.row];
    NSArray * userArr = dlgInfo.data[@"accepted_users"];
    NSArray * occupantUsers = dlgInfo.occupantIDs;
    
    for(id obj in occupantUsers)
    {
        NSInteger idx = [userArr indexOfObject: obj];
        if(idx == NSNotFound)
        {
            
        }
    }
}
- (void) reloadDialogs
{
    [[ChatService shared] requestDialogsWithCompletionBlock:^{
        [self setGroupListData: [ChatService shared].dialogs];
    }];
}
#pragma mark ChatService Delegate
- (BOOL) chatDidReceiveMessage:(QBChatMessage *)message
{
    NSString * notification_type = message.customParameters[@"notification_type"];
    if([notification_type isEqualToString: @"1"])
    {
        NSString * dlgID = message.customParameters[@"_id"];
        
        [[ChatService shared] requestDialogUpdateWithId:dlgID completionBlock:^{
            [self setGroupListData: [ChatService shared].dialogs];
        }];
        return YES;
    }
    else if([notification_type isEqualToString: NOTIFY_GROUP_CHAT_DECLINE])
    {
        NSString * dlgID = message.customParameters[@"_id"];
        [[ChatService shared] requestDialogUpdateWithId:dlgID completionBlock:^{
            [self setGroupListData: [ChatService shared].dialogs];
        }];
        return YES;
    }
    else if([notification_type isEqualToString: NOTIFY_GROUP_CHAT_DELETE])
    {
        NSString * dlgID = message.customParameters[@"_id"];
        [[ChatService shared] requestDialogUpdateWithId:dlgID completionBlock:^{
            [self setGroupListData: [ChatService shared].dialogs];
        }];
        return YES;
    }

    return NO;
}
- (BOOL) chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID
{
    return YES;
}
@end
