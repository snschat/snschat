//
//  ExUIView+Mask.m
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExUIView+Mask.h"
@implementation UIView(GradientMask)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CALayer *) addGlowLayer:(CGFloat)left :(CGFloat)right :(CGFloat)top :(CGFloat)bottom :(NSArray *)colors
{
    //left gradient
    CALayer * glowLayer;
    UIColor * color;
    CGFloat red, blue, green, alpha;

    
    glowLayer = [CALayer layer];
    
    glowLayer.frame = self.layer.bounds;
    
    CGFloat glowFactor = 0.3;
    if(left > 0)
    {
        color = [colors objectAtIndex: 0];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CAGradientLayer * leftLayer;
        leftLayer = [CAGradientLayer layer];
        leftLayer.frame = self.layer.bounds;
        leftLayer.startPoint = CGPointMake(0.0f, 0.5f);
        leftLayer.endPoint = CGPointMake(0.02f, 0.5f);
        
        leftLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:red green:green blue:blue alpha:glowFactor] CGColor], (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0.0f] CGColor], nil];
        
        [glowLayer addSublayer: leftLayer];
    
    }
    //right gradient
    if(right > 0)
    {
        color = [colors objectAtIndex: 1];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CAGradientLayer * rightLayer;
        rightLayer = [CAGradientLayer layer];
        rightLayer.frame = self.bounds;
        rightLayer.startPoint = CGPointMake(1.0f, 0.0f);
        rightLayer.endPoint = CGPointMake(1.0f - right, 0.0f);
        
        rightLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:red green:green blue:blue alpha:glowFactor] CGColor], (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0] CGColor], nil];
        
        [glowLayer addSublayer: rightLayer];
    }
    
    //top gradient
    if(top > 0)
    {
        color = [colors objectAtIndex: 2];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CAGradientLayer * topLayer;
        topLayer = [CAGradientLayer layer];
        topLayer.frame = self.bounds;
        topLayer.startPoint = CGPointMake(0.0f, 0);
        topLayer.endPoint = CGPointMake(0.0f, top);
        
        topLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:red green:green blue:blue alpha:glowFactor] CGColor], (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0] CGColor], nil];
        
        [glowLayer addSublayer: topLayer];
    }
    
    //bottom gradient
    if(bottom > 0)
    {
        color = [colors objectAtIndex: 3];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CAGradientLayer * bottomLayer;
        bottomLayer = [CAGradientLayer layer];
        bottomLayer.frame = self.bounds;
        bottomLayer.startPoint = CGPointMake(0.0f, 1.0f);
        bottomLayer.endPoint = CGPointMake(0.0f, 1.0f - bottom);

        
        bottomLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:red green:green blue:blue alpha:glowFactor] CGColor], (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0] CGColor], nil];
        
        [glowLayer addSublayer: bottomLayer];
    }
    [self.layer addSublayer: glowLayer];
    return glowLayer;
}

@end
