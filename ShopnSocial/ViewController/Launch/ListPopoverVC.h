//
//  ListPopoverVC.h
//  ShopnSocial
//
//  Created by rock on 5/2/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListPopoverDelegate <NSObject>

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ListPopoverVC : UITableViewController

@property (nonatomic, strong) NSArray* items;

@property (nonatomic, strong) id<ListPopoverDelegate> delegate;

@end
