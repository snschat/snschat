//
//  SharedProductCell.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ProductCell.h"
#import "ExUILabel+AutoSize.h"

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) populateWithData:(Product *) data
{
    if([data.img hasPrefix:@"http://"])
    {
        
    }
    else
        self.productImg.image = [UIImage imageNamed:data.img];
    
    self.productName.text = data.productName;
    [self.productName sizeToFit];
    
    self.productDesc.text = data.productDesc;
    [self.productDesc sizeToFit];
}
+(CGFloat) expectedHeight:(CGFloat) cellWidth :(Product *) cellData
{
    CGFloat imgHeight = 155;
    CGFloat nameHeight;
    CGFloat descHeight;
    
    UIFont * boldFont = [UIFont boldSystemFontOfSize:14];
    UIFont * regularFont = [UIFont systemFontOfSize:14];
    
    nameHeight = [UILabel expectedHeight:cellWidth :boldFont :cellData.productName];
    descHeight = [UILabel expectedHeight:cellWidth :regularFont :cellData.productDesc];
    
    
    CGFloat height = imgHeight + nameHeight + descHeight;
    return height + 60;
}
@end
