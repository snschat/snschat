//
//  SnsCategoryPageVC.h
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"
#import "ExUIView+Title.h"
#import "SnsPageView.h"
#import "JOLImageSlider.h"

@interface SnsCategoryPageVC : UIViewController <JOLImageSliderDelegate>

@property (nonatomic, strong) ProductCategory* cateogry;

@end
