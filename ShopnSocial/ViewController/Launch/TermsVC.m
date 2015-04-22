//
//  TermsVC.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "TermsVC.h"

@interface TermsVC ()

@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"]];
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
