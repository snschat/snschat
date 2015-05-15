//
//  ChatService.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/21/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import "User.h"
#import "Contact.h"

#define kDialogUpdatedNotification @"kDialogUpdatedNotification"

@protocol ChatServiceDelegate <NSObject>
- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message;
- (void)chatDidReadMessageWithID:(NSString *) messageID;
- (BOOL)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID;
- (void)chatDidLogin;
- (void) chatContactListDidChange:(QBContactList *)contactList;
- (void) chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status;
- (void) chatContactUsersDidChange:(NSMutableArray *) contactUsers;
- (void) chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID;
@end

@interface ChatService : NSObject

@property (nonatomic, readonly) QBUUser *currentUser;

@property (nonatomic, strong) NSMutableArray * delegates;

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, readonly) NSDictionary *usersAsDictionary;

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (nonatomic, strong) NSMutableDictionary *messages;

@property (nonatomic, strong) NSMutableArray * contactUsers;
@property (nonatomic, strong) NSMutableArray * waitingUsers;

+ (instancetype)shared;

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock;
- (void)logout;

- (void)sendMessage:(QBChatMessage *)message;
- (void)sendMessage:(QBChatMessage *)message sentBlock:(void (^)(NSError *error))sentBlock;
- (void)sendMessage:(QBChatMessage *)message toRoom:(QBChatRoom *)chatRoom;

- (void)joinRoom:(QBChatRoom *)room completionBlock:(void(^)(QBChatRoom *))completionBlock;
- (void)leaveRoom:(QBChatRoom *)room;

- (NSMutableArray *)messagsForDialogId:(NSString *)dialogId;
- (void)addMessages:(NSArray *)messages forDialogId:(NSString *)dialogId;
- (void)addMessage:(QBChatAbstractMessage *)message forDialogId:(NSString *)dialogId;

- (void)requestDialogsWithCompletionBlock:(void(^)())completionBlock;
- (void)requestDialogUpdateWithId:(NSString *)dialogId completionBlock:(void(^)())completionBlock;
- (void) sendPresenceWithStatus:(NSString *) statusStr;
- (void) confirmAddContactRequest:(Contact *) user;
- (void) rejectAddContactRequest:(Contact *) user;
- (void) fetchContactList;

- (void) addDelegate:(id<ChatServiceDelegate>)delegate;
- (void) removeDelegate:(id<ChatServiceDelegate>) delegate;
@end