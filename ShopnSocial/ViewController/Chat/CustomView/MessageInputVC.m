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
#import "Message.h"
#define MESSAGE_COLOR_PURPLE [UIColor colorWithRed:0.597 green:0.199 blue:0.398 alpha:1.0f]
#define MESSAGE_COLOR_BLUE [UIColor colorWithRed:0.218 green:0.507 blue:0.695 alpha:1.0f]
@interface MessageInputVC ()
{
    NSMutableArray * messageData;
    UIFont * nameTextFont;
    UIFont * msgTextFont;
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
    Message * msg = [Message new];
    msg.senderName = @"Contact1";
    msg.senderId = @"Contact1";
    msg.message = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.";
    msg.status = @"Read";
    
    messageData = [NSMutableArray array];
    [messageData addObject: msg];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier: @"chat_message_cell"];
    
    //TODO: Populate with message data
    Message * msg = [messageData objectAtIndex: indexPath.row];
    cell.nameText.text = msg.senderName;
    cell.messageText.text = msg.message;
    cell.statusText.text = msg.status;
    
    //Sent from me.
    if([msg.senderId isEqualToString: @"Me"])
    {
        cell.containerView.backgroundColor = MESSAGE_COLOR_PURPLE;
    }
    else
    {
        cell.containerView.backgroundColor = MESSAGE_COLOR_BLUE;
    }
    [cell.nameText sizeToFit];
    [cell.messageText sizeToFit];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Message * msg = [messageData objectAtIndex: indexPath.row];
    CGFloat nameTextHeight = [UILabel expectedHeight:64.0f :nameTextFont :msg.senderName];
    CGFloat messageTextHeight = [UILabel expectedHeight:420 :msgTextFont :msg.message];
    CGFloat maxHeight = MAX(nameTextHeight, messageTextHeight);
    return maxHeight + 50;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    prevFrame = textView.frame;
}

@end
