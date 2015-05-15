//
//  StatusOptionVC.m
//  ShopnSocial
//
//  Created by rock on 5/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "StatusOptionVC.h"
#import "User.h"

@interface StatusOptionVC ()
{
    NSInteger currentStatus;
    
    UIFont * itemFont;
    NSArray * statusNames;
}
@end

@implementation StatusOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    itemFont = [UIFont boldSystemFontOfSize: 18];
    statusNames = [NSArray arrayWithObjects:@"Online", @"Busy", @"Away", @"Appear Offline", nil];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view from its nib.
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
- (void) setCurrentStatusStr:(NSString *) statusStr
{
    NSInteger idx = [statusNames indexOfObject: statusStr];
    currentStatus = idx;
    [self.tableView reloadData];
}
- (void) setCurrentStatus:(NSInteger) status
{
    currentStatus = status;
    [self.tableView reloadData];
    //Get label under menu item view
}
- (NSInteger) currentStatus
{
    return currentStatus;
}
- (void) changeStatusTo:(NSInteger) statusIdx
{
    NSString * statusStr = @"Online";
    
    switch(statusIdx)
    {
        case 0:
            statusStr = @"Online";
            break;
        case 1:
            statusStr = @"Busy";
            break;
        case 2:
            statusStr = @"Away";
            break;
        case 3:
            statusStr = @"Appear Offline";
            break;
            
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL bResult = [User setCurrentUserStatusSync: statusStr];
        
        if(bResult)
        {
            currentStatus = statusIdx;
            //Dispatch main queue to update UI.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.delegate onChooseStatus:self :currentStatus];
            });
        }
    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return statusNames.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier: @"default"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"default"];
    }
    
    CGRect cellTextFrame = cell.textLabel.frame;
    cellTextFrame.origin.x = 10;
    cell.textLabel.font = itemFont;
    
    if(currentStatus == indexPath.row)
    {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    else
        cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.text = [statusNames objectAtIndex: indexPath.row];
    
    if([cell respondsToSelector: @selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self changeStatusTo: indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat) originalHeight
{
    return 205;
}

- (IBAction)onCollapseTouched:(id)sender {
    [self.delegate onCollapseTouched: self];
}

@end
