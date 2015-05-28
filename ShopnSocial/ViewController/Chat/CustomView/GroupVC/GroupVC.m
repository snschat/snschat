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

@interface GroupVC ()

@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib* nib = [UINib nibWithNibName: @"ContactListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"contact_list_cell"];
    
    //Table View separator setting
    [self.tableView setSeparatorColor: [UIColor whiteColor]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
    
    groupListData = [ChatService shared].dialogs;
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
    ContactListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contact_list_cell"];
    
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
    
    QBChatDialog* dlgInfo = [groupListData objectAtIndex: indexPath.row];
    
    //TODO: Populate data
    cell.contactName.text = dlgInfo.name;
    
    //TODO : status info for chat dialog.
    cell.status.text = @"";
    
    //TODO : load avatar image from QuickBlox
    [cell.avatarImgView setImageWithURL:[NSURL URLWithString: dlgInfo.photo] placeholderImage: [UIImage imageNamed: @"avatar_s1"]];
    cell.indexPath = indexPath;
    
    if(![[dlgInfo chatRoom] isJoined])
    {
        cell.delegate = self;
        [cell setAnnotations: @[@(ANNOT_CONFIRM)]];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: indexPath.row];
    if([[dlgInfo chatRoom] isJoined])
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
    [[dlgInfo chatRoom] joinRoom];
    
}

- (void) onDeclineTouched:(id) obj
{
    ContactListCell * cell = obj;
    QBChatDialog * dlgInfo = [groupListData objectAtIndex: cell.indexPath.row];
    //TODO : delete user from dialog
    
    dlgInfo.pullOccupantsIDs = @[@([User currentUser].UserID)];
    [QBRequest updateDialog: dlgInfo successBlock:^(QBResponse * response, QBChatDialog * dlgInfo) {
        [groupListData removeObject: dlgInfo];
        [self.tableView reloadData];
    } errorBlock:^(QBResponse *response) {
    }];
}
- (BOOL) chatDidReceiveMessage:(QBChatMessage *)message
{
//    if(message.customParameters)
    return NO;
}
@end
