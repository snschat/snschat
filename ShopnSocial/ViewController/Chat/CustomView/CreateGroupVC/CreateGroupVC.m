//
//  CreateGroupVC.m
//  ShopnSocial
//
//  Created by rock on 5/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//
#import "ExUIView+Border.h"
#import "CreateGroupVC.h"
#import "AddGroupTableCell.h"
#import "Contact.h"

@interface CreateGroupVC ()
{
    NSMutableArray * selectedContacts;
    BOOL bInit;
}
@end

@implementation CreateGroupVC

#pragma mark Override
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    bInit = false;
    selectedContacts = [NSMutableArray array];
}

- (void) setContacts:(NSArray *)contacts
{
    NSMutableArray * temp = [NSMutableArray array];
    for(Contact * contact in contacts)
    {
        if(!contact.bPending)
        {
            [temp addObject: contact];
        }
    }
    
    _contacts = [temp copy];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.view.superview.layer.cornerRadius = 0;
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    if(!bInit)
    {
        UIView *view = self.view;
        while (view != nil) {
            view = view.superview;
            if (view.layer.cornerRadius > 0) {
                view.layer.cornerRadius = 0;
                view = nil;
            }
        }
        
        //Add bottom border to top bar.
        [self.topbar addBorder:UIRectEdgeBottom color:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f] thickness:1.0f];
        
        //Table view setting.
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.tableHeaderView = [[UIView alloc] init];
        self.tableView.tableFooterView.backgroundColor= [UIColor whiteColor];
        self.tableView.tableHeaderView.backgroundColor= [UIColor whiteColor];
        CGRect tableFrame = self.tableView.frame;
        [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, tableFrame.size.width, 1)];
        [self.tableView.tableFooterView setFrame:CGRectMake(0, 0, tableFrame.size.width, 1)];
        
        [self updateCreateBtnStatus];
    }
    else
    {
        bInit = true;
    }
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
- (void) updateCreateBtnStatus
{
    [self setCreateBtnStatus: [self isAvailableCreate]];
}
- (void) setCreateBtnStatus:(BOOL) status
{
    if(status)
    {
        self.createGroupBtn.layer.opacity = 1.0f;
    }
    else
    {
        self.createGroupBtn.layer.opacity = 0.1f;
    }
}

- (BOOL) isAvailableCreate
{
    return selectedContacts.count != 0;
}

#pragma mark UIButton Events
- (IBAction)onCreateGroupTouched:(id)sender {
    if([self isAvailableCreate])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL bResult = [[ChatService shared] createChatGroupSync:selectedContacts title:self.groupNameTxt.text];
            if(bResult)
            {
                if([self.delegate respondsToSelector:@selector(onGroupDialogCreated)])
                    [self.delegate onGroupDialogCreated];
            }
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)onBackTouched:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddGroupTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddGroupTableCell"];
    Contact * user = [self.contacts objectAtIndex: indexPath.row];
    [cell setContact: user];
    if([selectedContacts indexOfObject: user] != NSNotFound)
    {
        [cell setCellStatus: STATUS_ADDED];
    }
    else
        [cell setCellStatus: STATUS_NONE];
    
    cell.delegate = self;
    return cell;
}

- (BOOL) cellOnAddTouched:(id) tableCell :(id) contact
{
    [selectedContacts addObject: contact];
    [self updateCreateBtnStatus];
    return true;
}
- (BOOL) cellOnRemoveTouched:(id) tableCell :(id) contact
{
    [selectedContacts removeObject: contact];
    [self updateCreateBtnStatus];
    return true;
}

@end
