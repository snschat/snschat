//
//  ContactListVC.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ContactListVC.h"
#import "ContactListCell.h"
#import "User.h"
#import "Contact.h"
#import "ChatService.h"

@interface ContactListVC ()

@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dialogUpdated:)
//                                                 name:kDialogUpdatedNotification object:nil];

    
    // Do any additional setup after loading the view from its nib.
    UINib * nib = [UINib nibWithNibName:@"ContactListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"contact_list_cell"];
    
    //Set separator.
    [self.tableView setSeparatorColor: [UIColor whiteColor]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
    waitingList = [NSMutableArray array];
    availableList = [NSMutableArray array];
    contactList = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[ChatService shared] addDelegate:self];
    
    availableList = [ChatService shared].contactUsers;
    waitingList = [ChatService shared].waitingUsers;

    [self reloadTableData];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[ChatService shared] removeDelegate:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onAddContactTouched:(id)sender {
    [self.delegate onAddContactTouched];
}

- (void) setContactListData:(NSArray *) _listData
{
    availableList = [NSMutableArray arrayWithArray: _listData];
    [self reloadTableData];
}

#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //TODO: Delete contact
        Contact * contact = [contactList objectAtIndex: indexPath.row];
        [[QBChat instance] removeUserFromContactList: contact.user.qbuUser.ID];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactListCell * cell = [tableView dequeueReusableCellWithIdentifier: @"contact_list_cell"];

    if(cell == nil)
    {
        //Alloc new cell
        NSArray * controls = [[NSBundle mainBundle] loadNibNamed:@"ContactListCell" owner:nil options:nil];
        
        for(id control in controls)
        {
            if([control isKindOfClass:[ContactListCell class]])
            {
                cell = control;
                break;
            }
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    Contact * contact = [contactList objectAtIndex: indexPath.row];
    
    //TODO: Populate data
    
//    cell.avatarImgView.image = ;
    cell.contactName.text = contact.user.Username;
    cell.status.text = contact.user.customObject.fields[@"status"];
    cell.indexPath = indexPath;
    
    if(contact.bWaiting)
    {
        [cell setAnnotations: @[@CONTACT_ANNOT_CONFIRM]];
        cell.delegate = self;
    }
    else if(contact.bPending)
    {
        [cell setAnnotations: @[@CONTACT_ANNOT_AWAITING]];
    }
    else
    {
        [cell setAnnotations: @[]];
        NSArray * dialogs = [ChatService shared].dialogs;
        for(QBChatDialog * dialog in dialogs)
        {
            if(dialog.recipientID == contact.user.UserID &&  dialog.unreadMessagesCount > 0)
            {
                [cell setBadgeNumber: dialog.unreadMessagesCount];
                [cell setAnnotations:@[@(CONTACT_ANNOT_BADGE)]];
                break;
            }
                
        }
    }
    

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate)
    {
        id data = [contactList objectAtIndex: indexPath.row];
        [self.delegate onContactSelected: data];
    }
}
- (void) reloadTableData
{
    [contactList removeAllObjects];
    [contactList addObjectsFromArray: waitingList];
    [contactList addObjectsFromArray: availableList];
    [self.tableView reloadData];
}
#pragma mark ChatService Delegate

- (BOOL)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID
{
    return NO;//Not processed here
}
- (void)chatDidLogin
{
    
}
- (void) chatContactListDidChange:(QBContactList *)contactList
{
    
}
- (void) chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status
{
    
}

- (void) chatContactUsersDidChange:(NSMutableArray *) contactUsers
{
    availableList = contactUsers;
    [self reloadTableData];
}
- (void) chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID
{
    waitingList = [ChatService shared].waitingUsers;
    [self reloadTableData];
}

#pragma mark ContactListCellDelegate
- (void) onAcceptTouched:(id) cell
{
    ContactListCell * contactCell = cell;
    Contact * contact = [contactList objectAtIndex: contactCell.indexPath.row];
    [[ChatService shared] confirmAddContactRequest: contact];
}

- (void) onDeclineTouched:(id) cell
{
    ContactListCell * contactCell = cell;
    Contact * contact = [contactList objectAtIndex: contactCell.indexPath.row];
    [[ChatService shared] rejectAddContactRequest:contact];
}
- (BOOL) chatDidReceiveMessage:(QBChatMessage *)message
{
    NSArray * dialogs = [ChatService shared].dialogs;
    
    for(QBChatDialog * dialog in dialogs)
    {
        if([dialog.ID isEqualToString: message.customParameters[@"dialog_id"]])
        {
            dialog.unreadMessagesCount ++;
        }
    }
    
    [self.tableView reloadData];
    return YES;
}
@end
