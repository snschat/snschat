//
//  GroupVC.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "GroupVC.h"
#import "ContactListCell.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddGroupTouched:(id)sender {
}

- (void) setGroupListData:(NSArray *) _listData
{
    groupListData = [NSMutableArray arrayWithArray:_listData];
    
    [self.tableView reloadData];
    
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    id data = [groupListData objectAtIndex: indexPath.row];
    
    //TODO: Populate data
    //    cell.avatarImgView.image = ;
    //    cell.contactName.text = [NSString stringWithFormat: @"Contact%i", indexPath.row];
    //    cell.status.text = ;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //TODO: Delete group
    }
}

@end
