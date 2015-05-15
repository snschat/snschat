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

    [self.inputBox border:2.0f color:[UIColor lightGrayColor]];
    
    nameTextFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    msgTextFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    //Sample message data
    messageData = [NSMutableArray array];
    
    
    enhancedKeyboard = [[KSEnhancedKeyboard alloc] init];
    UIToolbar * toolbar = [enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES];
    enhancedKeyboard.delegate = self;
    self.inputBox.inputAccessoryView = toolbar;
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
    ChatMessageCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier: @"chat_message_cell"];
    
    //TODO: Populate with message data
    QBChatMessage *message = [[ChatService shared] messagsForDialogId: dialog.ID][indexPath.row];
    
    //Sent from me.
    if(message.recipientID == [User currentUser].qbuUser.ID)
    {
        cell.containerView.backgroundColor = MESSAGE_COLOR_BLUE;
    }
    else
    {
        cell.containerView.backgroundColor = MESSAGE_COLOR_PURPLE;
    }
    
    [cell configureCellWithMessage: message];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QBChatAbstractMessage *chatMessage = [[[ChatService shared] messagsForDialogId: dialog.ID] objectAtIndex:indexPath.row];
    NSString * senderName = [[ChatService shared].usersAsDictionary  objectForKey: @(chatMessage.senderID)];
    NSString * msgText = chatMessage.text;
    
    CGFloat nameTextHeight = [UILabel expectedHeight:64.0f :nameTextFont :@""];
    CGFloat messageTextHeight = [UILabel expectedHeight:420 :msgTextFont :msgText];
    CGFloat maxHeight = MAX(nameTextHeight, messageTextHeight);
    return maxHeight + 50;
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.inputBox.transform = CGAffineTransformMakeTranslation(0, -250);
        self.messageTable.frame = CGRectMake(self.messageTable.frame.origin.x,
                                                  self.messageTable.frame.origin.y,
                                                  self.messageTable.frame.size.width,
                                                  self.messageTable.frame.size.height-252);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.inputBox.transform = CGAffineTransformIdentity;
        self.messageTable.frame = CGRectMake(self.messageTable.frame.origin.x,
                                                  self.messageTable.frame.origin.y,
                                                  self.messageTable.frame.size.width,
                                                  self.messageTable.frame.size.height+252);
    }];
}
- (void) setChatDlg:(QBChatDialog *) dlg
{
    //Load previous messages
    dialog = dlg;
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
    
    [QBRequest messagesWithDialogID:dialog.ID
                    extendedRequest:lastMessageDateSent == nil ? nil : @{@"date_sent[gt]": @([lastMessageDateSent timeIntervalSince1970])}
                            forPage:nil
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page) {
                           if(messages.count > 0){
                               [[ChatService shared] addMessages:messages forDialogId:dialog.ID];
                           }
                           
                           [weakSelf.messageTable reloadData];
                           NSInteger count = [[ChatService shared] messagsForDialogId:dialog.ID].count;
                           if(count > 0){
                               [weakSelf.messageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0]
                                                                 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                           }                      
                       } errorBlock:^(QBResponse *response) {
                           
                       }];
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
    
    QBChatMessage * message = [QBChatMessage markableMessage];
    message.text = sendMsg;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    if(dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [dialog recipientID];
        message.senderID = [ChatService shared].currentUser.ID;
        
        [[ChatService shared] sendMessage:message];
        
        // save message
        [[ChatService shared] addMessage:message forDialogId: dialog.ID];
        
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
- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message
{
    if(message.senderID != dialog.recipientID){
        return NO;
    }
    
    // save message
    [[ChatService shared] addMessage:message forDialogId:dialog.ID];
    
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

@end
