//
//  AddProductVC.m
//  ShopnSocial
//
//  Created by rock on 5/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddProductVC.h"
#import "AddFavouriteCell.h"


@interface AddProductVC ()
@end

@implementation AddProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFavouriteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddFavouriteCell"];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self addProductToFavourite];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}
- (void) addProductToFavourite
{
    AddFavouriteCell * cell = (AddFavouriteCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell showResultMsg];
}
- (void) setCurrentProduct
{
    AddFavouriteCell * cell = (AddFavouriteCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell showAddView];
    
}
@end
