//
//  TermsVC.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "PrivacyVC.h"

@interface PrivacyVC ()

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation PrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"]];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onOK:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
