//
//  StatusOptionVC.h
//  ShopnSocial
//
//  Created by rock on 5/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StatusOptionVCDelegate
- (void) onChooseStatus:(id) sender :(NSInteger) status;
- (void) onCollapseTouched:(id) sender;
@end

@interface StatusOptionVC : UIViewController
@property(nonatomic, strong) id<StatusOptionVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(CGFloat) originalHeight;
- (void) setCurrentStatusStr:(NSString *) statusStr;
- (void) setCurrentStatus:(NSInteger) status;
- (NSInteger) currentStatus;

@end
