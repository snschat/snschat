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

@interface ContactListVC ()

@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    

    [[QBChat instance] addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) fetchContactList
{
    contactList = [NSMutableArray array];
    
    NSArray * contacts = [QBChat instance].contactList.contacts;
    NSArray * pendingContacts = [QBChat instance].contactList.pendingApproval;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * users = [User getUsersFromContactsSync: contacts];
        NSArray * pendingUsers = [User getUsersFromContactsSync: pendingContacts];
        for(User * user in users)
        {
            user.bPending = NO;
        }
        for(User * user in pendingUsers)
        {
            user.bPending = YES;
        }
        [contactList addObjectsFromArray: pendingUsers];
        [contactList addObjectsFromArray: users];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContactListData: contactList];
        });
    });
}

- (IBAction)onAddContactTouched:(id)sender {
    [self.delegate onAddContactTouched];
}

- (void) setContactListData:(NSArray *) _listData
{
    contactList = [NSMutableArray arrayWithArray: _listData];
    [self.tableView reloadData];
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
    User * user = [contactList objectAtIndex: indexPath.row];
    //TODO: Populate data
//    cell.avatarImgView.image = ;
    cell.contactName.text = user.Username;
    cell.status.text = user.customObject.fields[@"status"];

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

#pragma mark QBChat Delegate
- (void) chatContactListDidChange:(QBContactList *)contactList
{
    [self fetchContactList];
}
- (void) chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status
{
    
}

@end
