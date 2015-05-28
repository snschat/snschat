//
//  MessageInputVC.h
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "KSEnhancedKeyboard.h"
#import "ChatService.h"

@interface MessageInputVC : UIViewController<UITableViewDataSource, UITableViewDelegate, KSEnhancedKeyboardDelegate, ChatServiceDelegate>
{
    CGRect prevFrame;
    CGFloat keyboardHeight;
    CGFloat orgHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (weak, nonatomic) IBOutlet UITextView *inputBox;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeadingConstraint;

- (void) setChatDlg:(QBChatDialog *) dlg;
@end
