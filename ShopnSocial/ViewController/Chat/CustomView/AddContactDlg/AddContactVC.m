//
//  AddContactVC.m
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddContactVC.h"
#import "AddMediaContactVC.h"
#import "AddContactCell.h"
#import "User.h"
#import "ExNSString.h"

@interface AddContactVC ()
{

}
@end

@implementation AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Initialize UI components.
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] init];
    NSAttributedString * oldAttString = self.inviteLabel.attributedText;
    [attributeString appendAttributedString: oldAttString];
    [attributeString addAttribute: NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange) {0, [attributeString length]}];
    
    self.inviteLabel.attributedText = attributeString;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.resultMsg.hidden = YES;
    
    UINib * cellNib = [UINib nibWithNibName:@"AddContactCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"AddContactCell"];
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];}
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
- (IBAction)onAddTouched:(id)sender {
    NSIndexPath * selectedIndex = [self.tableView indexPathForSelectedRow];
    if(!selectedIndex)
        return;
    User * user = [self.userArr objectAtIndex: selectedIndex.row];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
        QBUUser * qbUser = [User getQBUserFromUserSync: user];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[QBChat instance] addUserToContactListRequest:qbUser.ID ];
        });

    });
}

- (IBAction)onInviteTouched:(id)sender {
    
}
- (IBAction)onTwitterConnectTouched:(id)sender {
    
}
- (IBAction)onFacebookConnectTouched:(id)sender {
    
}
- (IBAction)onDeviceConnectTouched:(id)sender {
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddMediaContactVC * mediaVC;
    if([segue.identifier isEqualToString: @"FacebookSegue"])
    {
        mediaVC =  segue.destinationViewController;
        [mediaVC setMediaType: MEDIA_FACEBOOK];
    }
    
    if([segue.identifier isEqualToString: @"TwitterSegue"])
    {
        mediaVC = segue.destinationViewController;
        [mediaVC setMediaType: MEDIA_TWITTER];
    }
    
    if([segue.identifier isEqualToString: @"DeviceSegue"])
    {
        mediaVC = segue.destinationViewController;
        [mediaVC setMediaType: MEDIA_DEVICE];
    }
}

- (void) searchUsersByName:(NSString *) name
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.userArr = [User searchUsersByNamePrefixSync: name];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.userArr.count > 0)
            {
                self.resultMsg.hidden = YES;
            }
            else
            {
                self.resultMsg.hidden = NO;
            }
            [self.tableView reloadData];
        });
    });
}
- (void) searchUsersByEmail:(NSString *) email
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.userArr = [User searchUsersByEmailPrefixSync: email];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.userArr.count > 0)
                self.resultMsg.hidden = YES;
            else
                self.resultMsg.hidden = NO;
            
            [self.tableView reloadData];
        });
    });

}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * curText = [NSMutableString stringWithString:textField.text];
    
    [curText replaceCharactersInRange:range withString:string];
    if([curText isValidEmail])
        [self searchUsersByEmail: curText];
    else
        [self searchUsersByName: curText];
    return YES;
}

#pragma mark UITableViewSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userArr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddContactCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddContactCell"];
    User * user = [self.userArr objectAtIndex: indexPath.row];
    cell.contactName.text = user.Username;
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.inviteBtn.hidden = YES;
    return cell;
}

@end
