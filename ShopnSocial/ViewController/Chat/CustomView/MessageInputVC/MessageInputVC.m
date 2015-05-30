//
//  MessageInputVC.m
//  ShopnSocial
//
//  Created by rock on 5/3/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "MessageInputVC.h"
#import "ExUIView+Border.h"
#import "ChatMessageCell.h"
#import "ExUILabel+AutoSize.h"
#import "ChatMessage.h"
#import "ChatNotifyCell.h"

//Models
#define MESSAGE_COLOR_PURPLE [UIColor colorWithRed:0.597 green:0.199 blue:0.398 alpha:1.0f]
#define MESSAGE_COLOR_BLUE [UIColor colorWithRed:0.218 green:0.507 blue:0.695 alpha:1.0f]
@interface MessageInputVC ()
{
    NSMutableArray * messageData;
    UIFont * nameTextFont;
    UIFont * msgTextFont;
    QBChatDialog * dialog;
    KSEnhancedKeyboard * enhancedKeyboard;
}
@end

@implementation MessageInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Initialize table view
    UINib * cellNib = [UINib nibWithNibName: @"ChatMessageCell" bundle:[NSBundle mainBundle]];
    
    [self.messageTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [self.messageTable registerNib:cellNib forCellReuseIdentifier:@"chat_message_cell"];
    
    //Register notification cell
    
    cellNib = [UINib nibWithNibName: @"ChatNotifyCell" bundle: [NSBundle mainBundle]];
    [self.messageTable registerNib: cellNib forCellReuseIdentifier: @"notify_message_cell"];

    [self.inputBox border:2.0f color:[UIColor lightGrayColor]];
    
    nameTextFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    msgTextFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    //Sample message data
    messageData = [NSMutableArray array];
    
    
    enhancedKeyboard = [[KSEnhancedKeyboard alloc] init];
    UIToolbar * toolbar = [enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES];
    enhancedKeyboard.delegate = self;
    self.inputBox.inputAccessoryView = toolbar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    keyboardHeight = 0;
    
    // Initialize message colors
    msgColors = [NSArray arrayWithObjects:
                 [UIColor colorWithRed:0.597 green:0.199 blue:0.398 alpha:1.0f],
                 [UIColor colorWithRed:0.218 green:0.507 blue:0.695 alpha:1.0f],
                 [UIColor colorWithRed:0.2   green:0.597 blue:0.2   alpha:1.0f], nil];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [[ChatService shared] addDelegate: self];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ChatService shared] removeDelegate: self];
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
- (void) setMessageData:(NSArray *) _msgList
{
    messageData = [NSMutableArray arrayWithArray: _msgList];
    [self.messageTable reloadData];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(dialog == nil)
        return 0;
    return [[[ChatService shared] messagsForDialogId: dialog.ID] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Populate with message data
    QBChatMessage *message = [[ChatService shared] messagsForDialogId: dialog.ID][indexPath.row];
    if(message.customParameters[@"notification_type"] == nil)
    {
    
        ChatMessageCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier: @"chat_message_cell"];
        
        NSInteger idx = [dialog.occupantIDs indexOfObject: @(message.senderID)];
        
        UIColor * cellColor = [self cellColorForUserIdx: idx];
        cell.containerView.backgroundColor = cellColor;
        
        [cell configureCellWithMessage: message];
        return cell;
    }
    else
    {
        ChatNotifyCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier: @"notify_message_cell"];
        [cell configureCellWithMessage: message];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QBChatAbstractMessage *chatMessage = [[[ChatService shared] messagsForDialogId: dialog.ID] objectAtIndex:indexPath.row];
    
    if(chatMessage.customParameters[@"notification_type"] == nil)
    {
        NSString * msgText = chatMessage.text;
        
        CGFloat nameTextHeight = [UILabel expectedHeight:64.0f :nameTextFont :@""];
        CGFloat messageTextHeight = [UILabel expectedHeight:420 :msgTextFont :msgText];
        CGFloat maxHeight = MAX(nameTextHeight, messageTextHeight);
        return maxHeight + 50;

    }
    else
    {
        
        CGFloat cellHeight = [ChatNotifyCell expectedHeight:tableView.frame.size.width :chatMessage.text];
        return cellHeight;
    }
}

- (void) setChatDlg:(QBChatDialog *) dlg
{
    //Load previous messages
    if(dialog.type == QBChatDialogTypeGroup)
    {
        [[ChatService shared] leaveRoom: [dlg chatRoom]];
    }

    dialog = dlg;
    if(dialog.type == QBChatDialogTypeGroup)
    {
        [[ChatService shared] joinRoom:[dlg chatRoom] completionBlock:^(QBChatRoom * room) {
        }];
    }
    [self syncMessages];
    
}
- (void) syncMessages
{
    NSArray *messages = [[ChatService shared] messagsForDialogId:dialog.ID];
    NSDate *lastMessageDateSent = nil;
    if(messages.count > 0){
        QBChatAbstractMessage *lastMsg = [messages lastObject];
        lastMessageDateSent = lastMsg.datetime;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL bResult = [[ChatService shared] loadHistoryForDialogIDSync:dialog.ID :lastMessageDateSent];
        if(bResult)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.messageTable reloadData];
                NSInteger count = [[ChatService shared] messagsForDialogId:dialog.ID].count;
                if(count > 0){
                    [weakSelf.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0]
                                                 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            });
        }
    });
}

#pragma mark KSEnhancedKeyboard
- (void)nextDidTouchDown
{
    
}
- (void)previousDidTouchDown
{
    
}

- (void)doneDidTouchDown
{
    NSString * sendMsg = self.inputBox.text;
    [self.inputBox resignFirstResponder];
    self.inputBox.text = @"";
    if(sendMsg.length == 0)
        return;
    
    [self sendMessage: sendMsg];
}
- (void) sendMessage:(NSString * )msg
{
    
    QBChatMessage * message = [QBChatMessage markableMessage];
    message.text = msg;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    if(dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [dialog recipientID];
        message.senderID = [ChatService shared].currentUser.ID;
        [[ChatService shared] sendMessage:message];
        
        // save message
        
        [[ChatService shared] addMessage:[ChatMessage messageWithChatMessage: message] forDialogId: dialog.ID];
        
        // Group Chat
    }else {
        [[ChatService shared] sendMessage:message toRoom:[dialog chatRoom]];
    }
    
    [self.messageTable reloadData];
    
    if([[ChatService shared] messagsForDialogId: dialog.ID].count > 0){
        [self.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:dialog.ID] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}
#pragma mark ChatService Delegate
- (void)chatDidReadMessageWithID:(NSString *)messageID
{
    [self.messageTable reloadData];
}

- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message
{
    if(message.senderID != dialog.recipientID){
        return NO;
    }
    
    // save message
    if([message markable])
    {
        [[QBChat instance] readMessage: message];
    }
    
    ChatMessage * msgWrapper = [ChatMessage messageWithChatMessage:message];
    msgWrapper.read = YES;
    
    [[ChatService shared] addMessage:msgWrapper forDialogId:dialog.ID];
    
    // Reload table
    [self.messageTable reloadData];
    if([[ChatService shared] messagsForDialogId: dialog.ID].count > 0){
        [self.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId: dialog.ID] count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    return YES;
}

- (BOOL)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID
{
    if(![[dialog chatRoom].JID isEqualToString:roomJID]){
        return NO;
    }
    
    // save message
    [[ChatService shared] addMessage:message forDialogId: dialog.ID];
    
    // Reload table
    [self.messageTable reloadData];
    if([[ChatService shared] messagsForDialogId: dialog.ID].count > 0){
        [self.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId: dialog.ID] count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return YES;
}
- (void)chatDidLogin
{
}
- (void) chatContactListDidChange:(QBContactList *)contactList
{
    
}
- (void) chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status
{
    
}
- (void) chatContactUsersDidChange:(NSMutableArray *) contactUsers
{
    
}
- (void) chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID
{
    
}
#pragma mark Keyboard Delegate
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inputBox.transform = CGAffineTransformMakeTranslation(0, -height);
        self.messageTable.frame = CGRectMake(self.messageTable.frame.origin.x,
                                                  self.messageTable.frame.origin.y,
                                                  self.messageTable.frame.size.width,
                                                  self.messageTable.frame.size.height - (height - keyboardHeight));
    }];
    keyboardHeight = height;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        self.inputBox.transform = CGAffineTransformIdentity;
        self.messageTable.frame = CGRectMake(self.messageTable.frame.origin.x,
                                             self.messageTable.frame.origin.y,
                                             self.messageTable.frame.size.width,
                                             self.messageTable.frame.size.height + keyboardHeight);
    }];
    keyboardHeight = 0;
}

#pragma mark Util Functions
- (UIColor *) cellColorForUserIdx:(NSInteger) idx
{
    if(msgColors.count > 0)
    {
        return [msgColors objectAtIndex: idx];
    }
    else{
        return [UIColor blueColor];
    }
}
@end
