//
//  MessageInputVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInputVC : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>
{
    CGRect prevFrame;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (weak, nonatomic) IBOutlet UITextView *inputBox;
- (void) setMessageData:(NSArray *) _msgList;
@end
