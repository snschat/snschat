//
//  CategoryPopoverVC.h
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductCategory.h"

@protocol CategoryPopoverDelegate;

@interface CategoryPopoverVC : UITableViewController

@property (nonatomic, strong) id<CategoryPopoverDelegate> delegate;

@end


@protocol CategoryPopoverDelegate <NSObject>

-(void)onTapCategory:(ProductCategory*)category;

@end