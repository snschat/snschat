//
//  InviteFriendDlg.m
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "InviteFriendDlg.h"

@interface InviteFriendDlg ()

@end

@implementation InviteFriendDlg

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (IBAction)onInviteTouched:(id)sender {
}
- (IBAction)onBackTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
