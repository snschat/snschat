//
//  TabButton.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "TabButton.h"


@interface TabButton ()

@property (nonatomic, strong) UIButton* imageClose;
@property (nonatomic, strong) UILabel* label;

@end

@implementation TabButton

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

-(id)init
{
    self = [super init];
    [self innerInit];
    return self;
}

-(void)innerInit
{
    _innerShadow = [[YIInnerShadowView alloc] initWithFrame:self.frame];
    _innerShadow.backgroundColor = [UIColor clearColor];
    _innerShadow.shadowRadius = 5;
    _innerShadow.shadowColor = [UIColor colorWithWhite:0 alpha:1];
    
    
    _imageClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageClose setImage:[UIImage imageNamed:@"ic_cross_tab"] forState:UIControlStateNormal];
    
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_innerShadow];
    [self addSubview:_imageClose];
    [self addSubview:_label];
    
    self.position = TabButtonPositionLeft;
    
    [self select:NO];
}

-(void)layoutSubviews
{
    _innerShadow.frame = self.bounds;
    _imageClose.frame = CGRectMake(self.bounds.size.width - 10 - 20,
                                     self.bounds.size.height / 2 - 20 / 2,
                                   20, 20);
    
    [_label sizeToFit];
    CGRect frame = _label.frame;
    frame.size.width = self.frame.size.width - 10 - 20;
    frame.origin.x = 0;
    frame.origin.y = self.frame.size.height / 2 - frame.size.height / 2;
    _label.frame = frame;
    
    _label.text = [self titleForState:UIControlStateNormal];
    _label.font = self.titleLabel.font;
    _label.textColor = self.titleLabel.textColor;
}

-(void)setPosition:(TabButtonPosition)position
{
    _innerShadow.shadowMask = (YIInnerShadowMask)position;
}

-(UIButton*)CloseButton
{
    return _imageClose;
}

-(BOOL) isSelected
{
    return _innerShadow.hidden;
}

-(void) select:(BOOL)isSelected
{
    if (isSelected)
    {
        _innerShadow.hidden = YES;
        _imageClose.hidden = NO;
    }
    else
    {
        _innerShadow.hidden = NO;
        _imageClose.hidden = YES;
    }
}

@end
