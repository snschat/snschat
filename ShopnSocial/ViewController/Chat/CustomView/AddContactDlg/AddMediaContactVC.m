//
//  AddMediaContactVC.m
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AddMediaContactVC.h"

@interface AddMediaContactVC ()

@end

@implementation AddMediaContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //Change UI Texts
    switch (mediaType) {
        case MEDIA_FACEBOOK:
            self.titleLabel.text = @"Add a social media contact";
            self.instructionLabel.text = @"Send contact requests to your Facebook friends";
            break;
        case MEDIA_TWITTER:
            self.titleLabel.text = @"Add a social media contact";
            self.instructionLabel.text = @"Send contact requests to your Twitter friends";
            break;
        case MEDIA_DEVICE:
            self.titleLabel.text = @"Add a Device contact";
            self.instructionLabel.text = @"Send contact requests to your friends";
            break;
        default:
            break;
    }
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
- (void) setMediaType:(NSInteger) _mediaType
{
    mediaType = _mediaType;
    

}
- (IBAction)onBackTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
