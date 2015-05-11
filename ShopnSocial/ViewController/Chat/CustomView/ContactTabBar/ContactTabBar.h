//
//  ContactTabBar.h
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactTabBarItem.h"
#import "YIInnerShadowView.h"

@protocol ContactTabBarDelegate
- (void) onSwitchTab:(ContactTabBarItem *) prev :(ContactTabBarItem *) current;
@end

@interface GlowView:UIView
@property(nonatomic, strong) CALayer * glowLayer;
@end

@interface ContactTabBar : UIView
{
    NSMutableArray * _tabBarData;
    
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *tabBtn;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *tabView;
@property (strong, nonatomic) IBOutletCollection(YIInnerShadowView) NSArray *tabShadowView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tabLabels;

@property(nonatomic, strong) id<ContactTabBarDelegate> delegate;

@property(nonatomic, strong, readonly) ContactTabBarItem * selectedItem;

-(void) selectItem:(ContactTabBarItem *) item;
-(void) selectItemAtIndex:(int) idx;
-(ContactTabBarItem *) itemAtIdx:(int)idx;
-(NSInteger) indexOfItem:(ContactTabBarItem *) item;

@end
