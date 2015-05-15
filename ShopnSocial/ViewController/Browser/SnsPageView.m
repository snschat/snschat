//
//  SnsPageView.m
//  ShopnSocial
//
//  Created by rock on 5/15/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SnsPageView.h"

@implementation SnsPageView
{
    NSMutableArray* viewStacks1;
    NSMutableArray* viewStacks2;
    
    UIView* currentView;
}

-(id)init
{
    self = [super init];
    [self innerInit];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self innerInit];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self innerInit];
    return self;
}

-(void)innerInit
{
    viewStacks1 = [NSMutableArray array];
    viewStacks2 = [NSMutableArray array];
    
    currentView = nil;
}

-(void) pushView:(UIView*)view
{
    if (currentView != nil)
    {
        [currentView removeFromSuperview];
        [viewStacks1 addObject:currentView];
        [viewStacks2 removeAllObjects];
    }
    
    currentView = view;
    [self addSubview:currentView];
}

-(void) goBack
{
    if (self.isEnableBack == NO) return;
    
    [viewStacks2 addObject:currentView];
    [currentView removeFromSuperview];
    
    currentView = [viewStacks1 lastObject];
    [viewStacks1 removeLastObject];
    
    [self addSubview:currentView];
}

-(void) goForward
{
    if (self.isEnableForward == NO) return;
    
    [viewStacks1 addObject:currentView];
    [currentView removeFromSuperview];
    
    currentView = [viewStacks2 lastObject];
    [viewStacks2 removeLastObject];
    
    [self addSubview:currentView];
    
}

-(BOOL) isEnableBack
{
    return viewStacks1.count > 0;
}

-(BOOL) isEnableForward
{
    return viewStacks2.count > 0;
}

@end
