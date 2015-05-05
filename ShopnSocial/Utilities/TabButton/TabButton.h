//
//  TabButton.h
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIInnerShadowView.h"

typedef enum {
    TabButtonPositionLeft       = YIInnerShadowMaskRight | YIInnerShadowMaskTop,
    TabButtonPositionMiddle     = YIInnerShadowMaskTop | YIInnerShadowMaskLeft | YIInnerShadowMaskRight,
    TabButtonPositionRight      = YIInnerShadowMaskLeft | YIInnerShadowMaskTop
} TabButtonPosition;


@interface TabButton : UIButton

@property (nonatomic, readwrite) TabButtonPosition position;
@property (nonatomic, strong) YIInnerShadowView* innerShadow;

-(void) select:(BOOL)isSelected;

@end
