//
//  SharedProductCell.h
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDesc;

+(CGFloat) expectedHeight:(CGFloat) cellWidth :(Product *) cellData;
- (void) populateWithData:(Product *) data;
@end
