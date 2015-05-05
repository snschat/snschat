//
//  ContactTabBar.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ContactTabBar.h"
#import "ExUIView+Mask.h"

@implementation GlowView
@end

@implementation ContactTabBar

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void) awakeFromNib
{
    _tabBarData = [NSMutableArray array];
    
    //Initialization of tapbar data.
    NSArray * titleList = @[@"Contact List", @"Groups"];
    
    for(NSString  *title in titleList)
    {
        ContactTabBarItem * item = [ContactTabBarItem new];
        item.title = title;
        [_tabBarData addObject: item];
    }
    [self _updateTabBar];
}

- (void) _updateTabBar
{
    for(int i = 0; i < self.tabLabels.count; i++)
    {
        UILabel * label = [self.tabLabels objectAtIndex: i];
        if(i < _tabBarData.count)
            label.text = ((ContactTabBarItem *)[_tabBarData objectAtIndex: i]).title;
    }
}

- (IBAction)onClickBtn:(id)sender {
    NSInteger idx = 0;
    for(UIButton * btn in self.tabBtn)
    {
        if(btn == sender)
        {
            idx = [self.tabBtn indexOfObject: sender];
        }
    }
    
    
    [self.delegate onSwitchTab:self.selectedItem :[_tabBarData objectAtIndex: idx]];
    [self selectItemAtIndex: idx];
}
-(void) selectItemAtIndex:(int) idx
{
    GlowView * view = [self.tabView objectAtIndex: idx];
    view.backgroundColor = [UIColor colorWithRed:0.082 green:0.468 blue:0.714 alpha:0.5];
    [view.glowLayer removeFromSuperlayer];
    
    UIColor * color = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0f];
    
    NSArray * array = [NSArray arrayWithObjects:color, color, [UIColor blackColor], [UIColor blackColor], nil];
    for(int i = 0; i < self.tabView.count; i++)
    {
        if(i != idx)
        {
            view = [self.tabView objectAtIndex: i];
            view.backgroundColor = [UIColor clearColor];
            
            CALayer * layer = [view addGlowLayer:0.05 :0.05 :0.1 :0.2 :array];
            view.glowLayer = layer;

            
        }
    }
}
-(void) selectItem:(ContactTabBarItem *)item
{
    NSInteger idx = [_tabBarData indexOfObject: item];
    [self selectItemAtIndex: idx];
}

-(ContactTabBarItem *) itemAtIdx:(int)idx
{
    return [_tabBarData objectAtIndex: idx];
}
-(NSInteger) indexOfItem:(ContactTabBarItem *) item
{
    return [_tabBarData indexOfObject: item];
    
}
@end
