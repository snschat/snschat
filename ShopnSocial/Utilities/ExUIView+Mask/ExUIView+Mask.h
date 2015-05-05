//
//  ExUIView+Mask.h
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(GradientMask)
- (CALayer *) addGlowLayer:(CGFloat)left :(CGFloat)right :(CGFloat)top :(CGFloat)bottom :(NSArray *)colors;

@end