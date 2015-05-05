//
//  ChatVC.m
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "FavoriteVC.h"
#import "ExUIView+Mask.h"
#import "ExUIView+Border.h"
#import "FXBlurView.h"
#import "MessageInputVC.h"
#import "SharedProductVC.h"

@interface FavoriteVC ()
{
    GroupVC * groupVC;
    ContactListVC * contactVC;
    ContactTabBar * tabBar;
}

@end

@implementation FavoriteVC

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
    
    //Add glow to background image
//    UIColor * color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0f];
//    [self.view addGlowLayer:0.02 :0 :0 :0.02 :[NSArray arrayWithObjects:color, color, color, color, nil]];
    
    //self.mainBoard.hidden = YES;
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
    
    //Place the UIImage in a UIImageView
    self.backImg.image = viewImage;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onCloseBtnTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
