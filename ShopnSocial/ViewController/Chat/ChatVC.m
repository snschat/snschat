//
//  ChatVC.m
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "User.h"
#import "ChatService.h"

#import "ChatVC.h"
#import "ExUIView+Mask.h"
#import "ExUIView+Border.h"
#import "FXBlurView.h"
#import "UIImageEffects.h"
#import "MessageInputVC.h"
#import "SharedProductVC.h"
#import "AddContactVC.h"
#import "CustomNavigationVC.h"
#import "MBProgressHUD.h"
#import "ExQBChatDialog.h"

@interface ChatVC ()
{
    GroupVC * groupVC;
    ContactListVC * contactVC;
    ContactTabBar * tabBar;
    StatusOptionVC * statusMenu;
    MessageInputVC * msgVC;
}

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //Initailize Tabbar
    NSArray * barControls = [[NSBundle mainBundle] loadNibNamed:@"ContactTabBar" owner:nil options:nil];
    
    for(id control in barControls)
    {
        if([control isKindOfClass: [ContactTabBar class]])
        {
            tabBar = control;
        }
    }
    
    CGRect frame = self.m_tabbarContainer.frame;
    frame.origin = CGPointZero;
    
    tabBar.frame = frame;
    tabBar.delegate = self;
    [self.m_tabbarContainer addSubview: tabBar];
    [tabBar selectItemAtIndex: 0];
    
    [self onSwitchTab:nil :[tabBar itemAtIdx: 0]];
    
    //Add glow to background image
    UIColor * color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
    [self.view addGlowLayer:0.02 :0 :0 :0.02 :[NSArray arrayWithObjects:color, color, color, color, nil]];
    
    self.mainBoard.hidden = YES;
    
    /*
     * Contact view setting.
     */
    frame = self.contactImg.frame;
    self.contactImg.layer.cornerRadius = frame.size.width / 2;
    self.contactImg.layer.masksToBounds = YES;
    
    /*
     * MessageBoard setting
     */
    frame = self.messageBoard.frame;
    frame.origin = CGPointZero;
    msgVC = [[MessageInputVC alloc] initWithNibName:@"MessageInputVC" bundle:[NSBundle mainBundle]];
    msgVC.view.frame = frame;
    [self addChildViewController: msgVC];
    [self.messageBoard addSubview: msgVC.view];
    [msgVC didMoveToParentViewController: self];
    
    /*
     * SharedProduct setting
     */
    frame = self.sharedBoard.frame;
    frame.origin = CGPointZero;
    
    SharedProductVC * productVC = [[SharedProductVC alloc] initWithNibName:@"SharedProductVC" bundle:[NSBundle mainBundle]];
    productVC.view.frame = frame;
    [self addChildViewController: productVC];
    [self.sharedBoard addSubview: productVC.view];
    [productVC didMoveToParentViewController: self];
    
    [self.sharedBoard border:1.0f color:[UIColor lightGrayColor]];
    
    /*
     * Status Option Menu Initialization
     */
    
    statusMenu = [[StatusOptionVC alloc] initWithNibName:@"StatusOptionVC" bundle:[NSBundle mainBundle]];
    statusMenu.view.hidden = YES;
    statusMenu.delegate = self;
    statusMenu.view.translatesAutoresizingMaskIntoConstraints = YES;
    [self addChildViewController: statusMenu];
    [self.view addSubview: statusMenu.view];
    [statusMenu didMoveToParentViewController: self];
    
    /*
     * Send initial state to all users within his contact.
     */
    NSString * statusStr = [User currentUser].customObject.fields[@"status"];
    [statusMenu setCurrentStatusStr: statusStr];
    [[ChatService shared] sendPresenceWithStatus: statusStr];
    
    self.m_profileName.text = [User currentUser].Username;
    self.m_profileStatus.text = statusStr;
    
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if([ChatService shared].currentUser == nil) //If user didn't login chat service, pop back to previous view.
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
    
    //Prepare background
    if(!self.backImg.image)
    {
        //Set default from underlayered view.
        int total_view = self.navigationController.viewControllers.count;
        
        if(total_view > 1)
        {
            //Get previous image.
            UIViewController * vc= [self.navigationController.viewControllers objectAtIndex:total_view - 2];
            [self prepareBackgroundImage:vc.view];
        }
    }
    
    
    [MBProgressHUD showHUDAddedTo: self.view animated:YES];
    [[ChatService shared] requestDialogsWithCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [contactVC reloadTableData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareBackgroundImage:(UIView *)underView
{
    //Prepare background image from screenshot of view.
    UIGraphicsBeginImageContext(underView.bounds.size);
    [underView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage * endImage = [UIImageEffects imageByApplyingBlurToImage:viewImage withRadius:30 tintColor:[UIColor clearColor] saturationDeltaFactor:1.5 maskImage:nil];
    
    //Place the UIImage in a UIImageView
    self.backImg.image = endImage;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onLogoBtnTouched:(id)sender {
    
}
- (IBAction)onNewChatBtnTouched:(id)sender {
    [self selectContactTab];
}
- (IBAction)onGroupChatBtnTouched:(id)sender {
    [self selectGroupTab];
}
- (IBAction)onCloseBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ContactTabBarDelegate
- (void) onSwitchTab:(ContactTabBarItem *) prev :(ContactTabBarItem *) current
{
    UIViewController *newVC;
    BOOL isNew = false;
    //Remove all subviews.
    if(prev == current)
        return;
    else
        [self.m_tabview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if([current.title isEqualToString: @"Contact List"])
    {
        //Contact list selected
        if(contactVC == nil)
        {
            contactVC = [[ContactListVC alloc] initWithNibName: @"ContactListVC" bundle:[NSBundle mainBundle]];
            contactVC.delegate = self;
            isNew = true;
        }
        newVC = contactVC;
    }
    else
    {
        //Group list selected
        if(groupVC == nil)
        {
            groupVC = [[GroupVC alloc] initWithNibName:@"GroupVC" bundle:[NSBundle mainBundle]];
            groupVC.delegate = self;
            isNew = true;
        }
        newVC = groupVC;
    }
    
    CGRect tabFrame = self.m_tabview.frame;
    tabFrame.origin = CGPointZero;
    newVC.view.frame = tabFrame;
    
    [self.m_tabview addSubview: newVC.view];
    if(isNew)
    {
        [self addChildViewController: newVC];
        [newVC didMoveToParentViewController: self];
    }
}

#pragma mark Profile Callback
- (IBAction)onProfileSettingTouched:(id)sender {
    
}

#pragma mark ContactListVCDelegate
- (void) onContactSelected:(id) _contact
{
    Contact * contact = _contact;
    
    //Show chat view if contact was approved
    if(contact.bPending || contact.bWaiting)
    {
        self.mainBoard.hidden = YES;
        return;
    }
    
    self.contactName.text = contact.user.Username;
    self.contactStatus.text = contact.user.customObject.fields[@"status"];
    
    //Create chat dialog and attach to Message Input VC
    __block QBChatDialog * chatDlg;
    
    [[ChatService shared] requestDialogsWithCompletionBlock:^{
        
        for(QBChatDialog *dialog in [ChatService shared].dialogs)
        {
            switch (dialog.type) {
                case QBChatDialogTypePrivate:
                {
                    if(dialog.recipientID == contact.user.qbuUser.ID)
                        chatDlg = dialog;
                }
                    break;
                case QBChatDialogTypeGroup:
                {
                    
                }
                    break;
                case QBChatDialogTypePublicGroup:
                {
                    
                }
                default:
                    break;
            }
        }
        if(chatDlg == nil)
        {
            chatDlg = [QBChatDialog new];
            chatDlg.type = QBChatDialogTypePrivate;
            chatDlg.occupantIDs = @[@(contact.user.qbuUser.ID)];
            [QBRequest createDialog: chatDlg successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
                [msgVC setChatDlg: createdDialog];
                self.mainBoard.hidden = NO;
            } errorBlock:^(QBResponse *response) {
                
            }];
        }
        else
        {
            [msgVC setChatDlg:chatDlg];
            self.mainBoard.hidden = NO;
        }
    }];
}

- (void) onAddContactTouched
{
    AddContactVC * addContactVC = [self.storyboard instantiateViewControllerWithIdentifier: @"AddContactVC"];
    CustomNavigationVC * nav = [[CustomNavigationVC alloc] initWithRootViewController:addContactVC];
    nav.navigationBarHidden = YES;
    UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController: nav];
    popover.delegate = self;
    
    //    nav.view.superview.layer.cornerRadius = 0;
    [popover presentPopoverFromRect:self.leftPane.frame inView:self.mainBoard permittedArrowDirections:0 animated:YES];
}

#pragma mark GroupVCDelegate
- (void) onGroupSelected:(id) group
{
    QBChatDialog * dialog = group;
    if(![dialog isAccepted: [ChatService shared].currentUser])
        return;
    
    self.mainBoard.hidden = NO;
    self.contactName.text = dialog.name;
    //TODO : Load chat dialog photo
    //    self.contactImg.image = dialog.photo;
    
    //TODO : Dialog online status
    //    self.contactStatus.text = contact.user.customObject.fields[@"status"];
    
    //Create chat dialog and attach to Message Input VC
    [msgVC setChatDlg: dialog];
    self.mainBoard.hidden = NO;
}

//Invoked when create group button was touched.
- (void) showCreateGroup
{
    CreateGroupVC * vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CreateGroupVC"];
    vc.delegate = self;
    vc.contacts = [ChatService shared].contactUsers;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    popover.delegate = self;
    [popover presentPopoverFromRect:self.leftPane.frame inView:self.mainBoard permittedArrowDirections:0 animated:YES];
    
}

#pragma mark StatusOptionVC Delegate
- (IBAction)onClickStatus:(id)sender {
    
    if(statusMenu.view.hidden == NO)
        return;
    
    CGRect frame = self.profileBar.frame;
    self.profileBar.frame = frame;
    
    frame.origin = [[self.profileBar superview] convertPoint:frame.origin toView:self.view];
    frame.size.height = 0;
    
    statusMenu.view.frame = frame;
    statusMenu.view.hidden = NO;
    
    frame.size.height = [statusMenu originalHeight];
    frame.origin.y -= [statusMenu originalHeight];
    [UIView animateWithDuration:0.5f animations:^{
        
        statusMenu.view.frame = frame;
    }];
}

- (void) onChooseStatus:(id) sender :(NSInteger) status
{
    self.m_profileStatus.text = [User currentUser].customObject.fields[@"status"];
    statusMenu.view.hidden = YES;
}
- (void) onCollapseTouched:(id)sender
{
    statusMenu.view.hidden = YES;
}
#pragma mark CreateGroupVC Delegate
- (void) onGroupDialogCreated
{
    [groupVC reloadDialogs];
}
#pragma mark Group/Contact Tab Control

- (void) selectGroupTab
{
    ContactTabBarItem * item = [tabBar itemAtIdx: 1];
    [tabBar selectItemAtIndex: 1];
    [self onSwitchTab:nil :item];
}
- (void) selectContactTab
{
    ContactTabBarItem * item = [tabBar itemAtIdx: 0];
    [tabBar selectItemAtIndex: 0];
    [self onSwitchTab: nil : item];
}

@end
