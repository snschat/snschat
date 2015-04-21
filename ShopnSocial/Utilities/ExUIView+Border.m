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

@end
