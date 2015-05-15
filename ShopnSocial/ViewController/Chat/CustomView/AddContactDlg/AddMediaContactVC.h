//
//  AddMediaContactVC.h
//  ShopnSocial
//
//  Created by rock on 5/11/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MEDIA_FACEBOOK 1
#define MEDIA_TWITTER 2
#define MEDIA_DEVICE 3
@interface AddMediaContactVC : UIViewController
{
    NSInteger mediaType;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void) setMediaType:(NSInteger) _mediaType;
@end
