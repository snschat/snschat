//
//  CustomNavigationVC.m
//  ShopnSocial
//
//  Created by rock on 5/20/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "CustomNavigationVC.h"

@interface CustomNavigationVC ()

@end

@implementation CustomNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.superview.layer.cornerRadius = 0;
    //    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    UIView *view = self.view;
    while (view != nil) {
        view = view.superview;
        if (view.layer.cornerRadius > 0) {
            view.layer.cornerRadius = 0;
            view = nil;
        }
    }
    //    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
