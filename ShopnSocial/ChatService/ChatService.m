//
//  ChatService.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/21/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "ChatService.h"
#import "ChatMessage.h"

#define MAX_MESSAGE_HISTORY 5000

typedef void(^CompletionBlock)();
typedef void(^JoinRoomCompletionBlock)(QBChatRoom *);
typedef void(^CompletionBlockWithResult)(NSArray *);

@interface ChatService () <QBChatDelegate>

@property (retain) NSTimer *presenceTimer;

@property (copy) CompletionBlock loginCompletionBlock;
@property (copy) JoinRoomCompletionBlock joinRoomCompletionBlock;
@property (copy) CompletionBlock getDialogsCompletionBlock;

@end


@implementation ChatService

+ (instancetype)shared{
    static id instance_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    
    return instance_;
}

- (id)init{
    self = [super init];
    if(self){
        [[QBChat instance] addDelegate:self];
        //
        [QBChat instance].autoReconnectEnabled = YES;
        //
        [QBChat instance].streamManagementEnabled = YES;
        
        self.delegates = [NSMutableArray array];
        self.messages = [NSMutableDictionary dictionary];
        self.contactUsers = [NSMutableArray array];
        self.waitingUsers = [NSMutableArray array];
    }
    return self;
}

- (QBUUser *)currentUser{
    return [[QBChat instance] currentUser];
}

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock{
    self.loginCompletionBlock = completionBlock;
    
    [[QBChat instance] loginWithUser:user];
}

- (void)logout{
    [[QBChat instance] logout];
}
- (void) sendPresenceWithStatus:(NSString *) statusStr
{
    [[QBChat instance] sendPresenceWithStatus: statusStr];
}

- (void)sendMessage:(QBChatMessage *)message{
    [[QBChat instance] sendMessage:message];

}

- (void)sendMessage:(QBChatMessage *)message sentBlock:(void (^)(NSError *error))sentBlock{
    [[QBChat instance] sendMessage:message sentBlock:^(NSError *error) {
        sentBlock(error);
    }];
}

- (void)sendMessage:(QBChatMessage *)message toRoom:(QBChatRoom *)chatRoom{
    [[QBChat instance] sendChatMessage:message toRoom:chatRoom];
}

- (void)joinRoom:(QBChatRoom *)room completionBlock:(void(^)(QBChatRoom *))completionBlock{
    self.joinRoomCompletionBlock = completionBlock;
    
    [room joinRoomWithHistoryAttribute:@{@"maxstanzas": @"0"}];
}

- (void)leaveRoom:(QBChatRoom *)room{
    [[QBChat instance] leaveRoom:room];
}
- (void) createRoom: (NSString *) roomName :(NSArray *) occupantIDs
{
    QBChatDialog * chatDialog = [QBChatDialog new];
    chatDialog.name = roomName;
    chatDialog.type = QBChatDialogTypeGroup;
    chatDialog.occupantIDs = occupantIDs;
    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        
    } errorBlock:^(QBResponse *response) {
        
    }];
}

- (void)setUsers:(NSMutableArray *)users
{
    _users = users;
    
    NSMutableDictionary *__usersAsDictionary = [NSMutableDictionary dictionary];
    for(QBUUser *user in users){
        [__usersAsDictionary setObject:user forKey:@(user.ID)];
    }
    
    _usersAsDictionary = [__usersAsDictionary copy];
}

- (NSMutableArray *)messagsForDialogId:(NSString *)dialogId{
    NSMutableArray *messages = [self.messages objectForKey:dialogId];
    if(messages == nil){
        messages = [NSMutableArray array];
        [self.messages setObject:messages forKey:dialogId];
    }
    return messages;
}

- (BOOL) loadHistoryForDialogIDSync:(NSString *) dialogID :(NSDate *) fromDate
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block BOOL bResult = FALSE;
    [QBRequest messagesWithDialogID:dialogID
                    extendedRequest:fromDate == nil ? nil : @{@"date_sent[gt]": @([fromDate timeIntervalSince1970])}
                            forPage:nil
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page) {
                           if(messages.count > 0){
                               [[ChatService shared] addMessages:messages forDialogId:dialogID];
                           }
                           bResult = TRUE;
                           dispatch_semaphore_signal(sema);
                           
                       } errorBlock:^(QBResponse *response) {
                           bResult = FALSE;
                           dispatch_semaphore_signal(sema);
                       }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return bResult;
}

- (void)addMessages:(NSArray *)messages forDialogId:(NSString *)dialogId{
    NSMutableArray *messagesArray = [self.messages objectForKey:dialogId];
    if(messagesArray != nil){
        [messagesArray addObjectsFromArray:messages];
    }else{
        [self.messages setObject:messages forKey:dialogId];
    }
}

- (void)addMessage:(QBChatAbstractMessage *)message forDialogId:(NSString *)dialogId{
    NSMutableArray *messagesArray = [self.messages objectForKey:dialogId];
    if(messagesArray != nil){
        
        [messagesArray addObject:message];
    }else{
        NSMutableArray *messages = [NSMutableArray array];
        [messages addObject:message];
        [self.messages setObject:messages forKey:dialogId];
    }
}

- (void)requestDialogsWithCompletionBlock:(void(^)())completionBlock{
    
    self.getDialogsCompletionBlock = completionBlock;
    
    [QBRequest dialogsWithSuccessBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs) {
        
        self.dialogs = dialogObjects.mutableCopy;
        
        [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:nil
                   successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                       
                       self.users = [NSMutableArray arrayWithArray:users];
                       
                       if(self.getDialogsCompletionBlock != nil){
                           self.getDialogsCompletionBlock();
                           self.getDialogsCompletionBlock = nil;
                       }
                       
                   } errorBlock:nil];
        
    } errorBlock:nil];
}

- (void)requestDialogUpdateWithId:(NSString *)dialogId completionBlock:(void(^)())completionBlock{
    self.getDialogsCompletionBlock = completionBlock;
    
    [QBRequest dialogsForPage:nil
              extendedRequest:@{@"_id": dialogId}
                 successBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page) {
                     
                     BOOL found = NO;
                     NSArray *dialogsCopy = [NSArray arrayWithArray:self.dialogs];
                     for(QBChatDialog *dialog in dialogsCopy){
                         if([dialog.ID isEqualToString:dialogId]){
                             [self.dialogs removeObject:dialog];
                             found = YES;
                             break;
                         }
                     }
                     
                     [self.dialogs insertObject:dialogObjects.firstObject atIndex:0];
                     
                     if(!found){
                         [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:nil
                                    successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
                                        
                                        [self.users addObjectsFromArray:users];
                                        
                                        if(self.getDialogsCompletionBlock != nil){
                                            self.getDialogsCompletionBlock();
                                            self.getDialogsCompletionBlock = nil;
                                        }
                                        
                                    } errorBlock:nil];
                     }else{
                         if(self.getDialogsCompletionBlock != nil){
                             self.getDialogsCompletionBlock();
                             self.getDialogsCompletionBlock = nil;
                         }
                     }
                     
                 } errorBlock:nil];
}


#pragma mark
#pragma mark QBChatDelegate

- (void)chatDidLogin{
    // Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    
    if(self.loginCompletionBlock != nil){
        self.loginCompletionBlock();
        self.loginCompletionBlock = nil;
    }
    for(id delegate in self.delegates)
    {
        if([delegate respondsToSelector:@selector(chatDidLogin)]){
            [delegate chatDidLogin];
        }
    }
}

- (void)chatDidFailWithError:(NSInteger)code{
    // relogin here
//    [[QBChat instance] loginWithUser: self.currentUser];
}

- (void)chatRoomDidEnter:(QBChatRoom *)room{
    self.joinRoomCompletionBlock(room);
    self.joinRoomCompletionBlock = nil;
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    
    // notify observers
    BOOL processed = NO;
    
    for(id<ChatServiceDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector:@selector(chatDidReceiveMessage:)]){
            processed |= [delegate chatDidReceiveMessage:message];
        }
    }
    
    if(!processed){
        NSString *dialogId = message.customParameters[@"dialog_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDialogUpdatedNotification object:nil userInfo:@{@"dialog_id": dialogId}];
    }
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID{
    
    // notify observers
    BOOL processed = NO;
    for(id<ChatServiceDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector:@selector(chatRoomDidReceiveMessage:fromRoomJID:)]){
            processed = [delegate chatRoomDidReceiveMessage:message fromRoomJID:roomJID];
        }
    }
    
//    if(!processed){
//        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"New message"
//                                                       description:message.text
//                                                              type:TWMessageBarMessageTypeInfo];
//        
//        [[SoundService instance] playNotificationSound];
//    }
}

- (void) chatContactListDidChange:(QBContactList *)contactList
{
    for(id<ChatServiceDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector: @selector(chatContactListDidChange:)])
        {
            [delegate chatContactListDidChange: contactList];
        }
    }
    [self fetchContactList];
}

- (void) chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status
{
    if(self.contactUsers && status)
    {
        for(Contact * contact in self.contactUsers)
        {
            if(contact.user.qbuUser.ID == userID)
            {
                if(isOnline)
                    contact.user.Status = status;
                else
                    contact.user.Status = @"Offline";
            }
        }
    }
    
    for(id<ChatServiceDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector: @selector(chatDidReceiveContactItemActivity:isOnline:status:)])
        {
            [delegate chatDidReceiveContactItemActivity:userID isOnline:isOnline status:status];
        }

    }
}

- (void) chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        User * user = [User getUserByIDSync: userID];
        
        Contact * contact = [Contact new];
        contact.user = user;
        contact.bWaiting = YES;
        
        [self.waitingUsers addObject: contact];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(id<ChatServiceDelegate> delegate in self.delegates)
            {
                if([delegate respondsToSelector: @selector(chatDidReceiveContactItemActivity:isOnline:status:)])
                {
                    [delegate chatDidReceiveContactAddRequestFromUser:userID];
                }
            }
        });
    });
}
- (void) chatDidReadMessageWithID:(NSString *)messageID
{
    //Mark the message as read.
    NSEnumerator * enumerator = self.messages.objectEnumerator;
    id obj;
    while((obj = [enumerator nextObject]) != nil)
    {
        NSArray * dlgMsgArr = obj;
        for(QBChatAbstractMessage * message in dlgMsgArr)
        {
            if([message.ID isEqualToString: messageID])
            {
                if([message isKindOfClass: [QBChatHistoryMessage class]])
                {
                    [(QBChatHistoryMessage *) message setRead: YES];
                }
                else if([message isKindOfClass: [ChatMessage class]])
                {
                    [(ChatMessage *) message setRead:YES];
                }
            }
        }
    }
    
    for(id<ChatServiceDelegate> delegate in self.delegates)
    {
        if([delegate respondsToSelector: @selector(chatDidReadMessageWithID:)])
        {
            [delegate chatDidReadMessageWithID: messageID];
        }
    }

}

- (void) confirmAddContactRequest:(Contact *) contact
{
    BOOL bResult = [[QBChat instance] confirmAddContactRequest: contact.user.qbuUser.ID];
    if(bResult)
        [self.waitingUsers removeObject: contact];
}

- (void) rejectAddContactRequest:(Contact *) contact
{
    BOOL bResult = [[QBChat instance] rejectAddContactRequest: contact.user.qbuUser.ID];
    
    if(bResult)
        [self.waitingUsers removeObject: contact];
}

- (void) fetchContactList
{
    NSArray * contacts = [QBChat instance].contactList.contacts;
    NSArray * pendingContacts = [QBChat instance].contactList.pendingApproval;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray * users = [User getUsersFromContactsSync: contacts];
        NSArray * pendingUsers = [User getUsersFromContactsSync: pendingContacts];
        
        self.contactUsers = [NSMutableArray array];
        for(User * user in users)
        {
            Contact * contact = [Contact new];
            contact.user = user;
            contact.bPending = NO;
            [self.contactUsers addObject: contact];
        }
        for(User * user in pendingUsers)
        {
            Contact * contact = [Contact new];
            contact.user = user;
            contact.bPending = YES;
            [self.contactUsers addObject: contact];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(id delegate in self.delegates)
            {
                [delegate chatContactUsersDidChange: self.contactUsers];
            }
        });
    });
}

- (void) addDelegate:(id<ChatServiceDelegate>)_delegate
{
    [self.delegates addObject:_delegate];
}
- (void) removeDelegate:(id<ChatServiceDelegate>) _delegate
{
    [self.delegates removeObject: _delegate];
}

- (BOOL) createChatGroupSync: (NSArray *) contacts title:(NSString *) name
{
    __block BOOL bResult;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableArray * _occupantIDs;
    _occupantIDs = [NSMutableArray array];
    
    for(Contact * contact in contacts)
    {
        [_occupantIDs addObject: @(contact.user.UserID)];
    }
    
    QBChatDialog * chatDialog = [QBChatDialog new];
    chatDialog.name = name;
    chatDialog.occupantIDs = _occupantIDs;
    chatDialog.type = QBChatDialogTypeGroup;
    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        for(NSString * occupantID in createdDialog.occupantIDs)
        {
            QBChatMessage * inviteMessage = [self createChatNotificationForGroupChatCreation: createdDialog];
            inviteMessage.recipientID = [occupantID integerValue];
            [[QBChat instance] sendMessage: inviteMessage];
        }
        bResult = YES;
        dispatch_semaphore_signal(sema);
    } errorBlock:^(QBResponse *response) {
        bResult = NO;
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return bResult;
}

- (QBChatMessage *) createChatNotificationForGroupChatCreation: (QBChatDialog *) dialog
{
    User * currentUser = [User currentUser];
    
    NSString * inviteMsg = [NSString stringWithFormat: @"%@ invited you to group chatting", currentUser.Username];
    
    QBChatMessage * inviteMessage = [QBChatMessage message];
    inviteMessage.text = inviteMsg;
    
    NSMutableDictionary * customParams = [NSMutableDictionary dictionary];
    customParams[@"xmpp_room_jid"] = dialog.roomJID;
    customParams[@"name"] = dialog.name;
    customParams[@"_id"] = dialog.ID;
    customParams[@"type"] = @(dialog.type);
    customParams[@"occupants_ids"] = [dialog.occupantIDs componentsJoinedByString:@","];
    
    customParams[@"notification_type"] = @"1";
    
    inviteMessage.customParameters = customParams;
    return inviteMessage;
}
@end