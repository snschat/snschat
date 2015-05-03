//
//  DatePopoverVC.h
//  ShopnSocial
//
//  Created by rock on 5/2/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePopoverDelegate <NSObject>

- (void) didSelectDate: (NSDate*) date;

@end

@interface DatePopoverVC : UIViewController

@property (nonatomic, strong) NSDate* selectedDate;
@property (nonatomic, strong) id<DatePopoverDelegate> delegate;

@end
