//
//  ExUIView+Border.h
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (exBorder)

- (void) border:(float) width color:(UIColor*) color;
- (CALayer *) addBorder:(UIRectEdge) edge color:(UIColor *) color thickness:(CGFloat)thickness;
@end
