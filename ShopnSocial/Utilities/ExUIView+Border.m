//
//  ExUIView+Border.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExUIView+Border.h"

@implementation UIView (exBorder)

- (void) border:(float) width color:(UIColor*) color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}
- (CALayer *) addBorder:(UIRectEdge) edge color:(UIColor *) color thickness:(CGFloat)thickness
{
    CALayer * border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    border.backgroundColor = color.CGColor;
    [self.layer addSublayer: border];
    
    return border;
}
@end
