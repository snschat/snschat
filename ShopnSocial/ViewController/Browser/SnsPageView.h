//
//  SnsPageView.h
//  ShopnSocial
//
//  Created by rock on 5/15/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnsPageView : UIView

-(void) pushView:(UIView*)view;

-(void) goBack;
-(void) goForward;

-(BOOL) isEnableBack;
-(BOOL) isEnableForward;

@end
