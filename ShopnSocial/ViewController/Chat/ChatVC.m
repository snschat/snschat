//
//  ChatVC.m
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ChatVC.h"
#import "ExUIView+Mask.h"
#import "ExUIView+Border.h"
#import "FXBlurView.h"
#import "UIImageEffects.h"
#import "MessageInputVC.h"
#import "SharedProductVC.h"

@interface ChatVC ()
{
    GroupVC * groupVC;
    ContactListVC * contactVC;
    ContactTabBar * tabBar;
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
    MessageInputVC * msgVC = [[MessageInputVC alloc] initWithNibName:@"MessageInputVC" bundle:[NSBundle mainBundle]];
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
    
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
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
    
}
- (IBAction)onGroupChatBtnTouched:(id)sender {
    
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
- (void) onContactSelected:(id) contact
{
    self.mainBoard.hidden = NO;
}

#pragma mark GroupVCDelegate
- (void) onGroupSelected:(id) group
{
    self.mainBoard.hidden = NO;
}

@end
