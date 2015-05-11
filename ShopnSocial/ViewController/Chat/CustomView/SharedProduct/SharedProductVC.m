//
//  SharedProductVC.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SharedProductVC.h"
#import "ProductCell.h"
#import "Product.h"

@interface SharedProductVC ()
{
    NSMutableArray * sharedProducts;
}
@end

@implementation SharedProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib * nib = [UINib nibWithNibName:@"ProductCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"product_cell"];
    
    
    //Prepare sample data
    sharedProducts = [NSMutableArray array];
    
    Product * product = [Product new];
    product.img = @"sample_product";
    product.productName = @"VALENTINO";
    product.productDesc = @"Contrast-panelled bow waist sleeveless wool-blend dress";
    
    [sharedProducts addObject: product];
    
    product = [Product new];
    product.img = @"sample_product";
    product.productName = @"BALMAN";
    product.productDesc = @"Geometric print dress";
    [sharedProducts addObject: product];
    
    
    //Table view setting
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
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
- (void) setSharedProducts:(NSArray *) _sharedProducts
{
    sharedProducts = [NSMutableArray arrayWithArray: _sharedProducts];
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sharedProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"product_cell"];
    
    
    Product * product = [sharedProducts objectAtIndex: indexPath.row];
    [cell populateWithData: product];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.view.frame;
    
    Product * product = [sharedProducts objectAtIndex: indexPath.row];
    CGFloat height = [ProductCell expectedHeight:frame.size.width :product];
    return height;
}
@end
