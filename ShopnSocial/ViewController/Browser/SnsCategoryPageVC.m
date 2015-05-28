//
//  SnsCategoryPageVC.m
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SnsCategoryPageVC.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"


@implementation SnsCategoryPageVC
{
    IBOutlet UILabel *labelText;
    IBOutlet UIScrollView *scrollView;
}

-(void)viewDidLoad
{
    [self loadData];
}

-(void) loadData
{
    if (self.cateogry == nil) return;
    
    labelText.text = self.cateogry.Name;
    
    self.view.title = [NSString stringWithFormat:@"Category - %@", self.cateogry.Name];

    if ([self.view.superview isKindOfClass:[SnsPageView class]])
    {
        SnsPageView* container = (SnsPageView*)self.view.superview;
        
        [container fireTitleChange:self.title sender:self.view];
    }
    
    for (UIView* _v in scrollView.subviews) {
        [_v removeFromSuperview];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* stores = [Store getStoresInCategorySync:self.cateogry];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float x, y, w, h;
            x = 0;
            y = 0;
            w = self.view.frame.size.width;
            h = 100;
            
            int idx = 0;
            int count = stores.count;
            int rows = count / 4 + (count % 4 != 0 ? 1 : 0);
            for (int r = 0; r < rows; r++) {
                UIView* rowview = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                
                rowview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                
                int cols = 4;
                
                if (r == rows - 1)
                {
                    cols = count - r * 4;
                    w = w * cols / 4;
                    
                }
                
                for (int c = 0; c < cols; c++) {
                    Store* st = [stores objectAtIndex:idx++];
                    
                    UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(c * w / cols, 0, w / cols, h)];
                    
                    UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, cell.frame.size.width - 20, 48)];
                    imageview.contentMode = UIViewContentModeScaleAspectFit;
                    [imageview setImageWithURL:[NSURL URLWithString:st.LogoURL]];
                    
                    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, cell.frame.size.width - 20, 50)];
                    label.lineBreakMode = NSLineBreakByWordWrapping;
                    label.numberOfLines = 3;
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [UIColor colorWithRed:119 / 255.0f green:173 / 255.0f blue:207 / 255.0f alpha:1];
                    label.text = st.Description;
                    
                    [cell addSubview:imageview];
                    [cell addSubview:label];

                    if (c != cols - 1)
                    {
                        UIView* seperater = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cell.frame.size.height - 10)];
                        seperater.backgroundColor = [UIColor whiteColor];
                        seperater.center = CGPointMake((c+1) * w / cols, cell.frame.size.height / 2);
                        [rowview addSubview:seperater];
                    }
                    
                    [rowview addSubview:cell];
                    
                    cell.title = st.AffiliateURL;
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
                    [cell addGestureRecognizer:tap];
                }
                
                rowview.frame = CGRectMake(x, y, w, h);
                
                [scrollView addSubview:rowview];
                
                y += h + 1;
            }
            
            scrollView.contentSize = CGSizeMake(0, y + 200);
        });
    });
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    NSString* url = gestureRecognizer.view.title;
    NSLog(@"Click Category Item : %@", url);
    
    if ([self.view.superview isKindOfClass:[SnsPageView class]])
    {
        SnsPageView* container = (SnsPageView*)self.view.superview;
        
        [container openURL:url];
    }
}


@end
