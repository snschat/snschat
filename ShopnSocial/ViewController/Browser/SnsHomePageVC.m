//
//  SnsHomePageVC.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SnsHomePageVC.h"
#import "JOLImageSlider.h"
#import "Global.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ExUIView+Title.h"

@interface SnsHomePageVC () <JOLImageSliderDelegate>


@property (strong, nonatomic) IBOutlet JOLImageSlider *featuredBrandSlider;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollRecommedBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollOfferView;

@end


@implementation SnsHomePageVC


-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];

    [self createFeaturedBar];
    [self createRecommendBar];
    [self createOfferView];
    
    self.view.title = @"Shop n Social Official Home Page - For tablets";
    
    if ([self.view.superview isKindOfClass:[SnsPageView class]])
    {
        SnsPageView* container = (SnsPageView*)self.view.superview;        
        [container fireTitleChange:self.title sender:self.view];
    }
}

- (void) imagePager:(JOLImageSlider *)imagePager didSelectImageAtIndex:(NSUInteger)index imageview:(UIImageView *)imageView {
    NSLog(@"Selected slide at index: %i", index);
    
    JOLImageSlide* slide = [self.featuredBrandSlider.slideArray objectAtIndex:index];
    NSString* url = slide.url;
    NSLog(@"Click Featured Item : %@", url);
    
    if ([self.view.superview isKindOfClass:[SnsPageView class]])
    {
        SnsPageView* container = (SnsPageView*)self.view.superview;
        
        [container openURL:url];
    }
}

- (void) createFeaturedBar
{
    NSMutableArray* slideSet = [NSMutableArray array];
    NSArray* featuredStores = [[Global sharedGlobal] getFeatureStoreSync];
    for (FeaturedStore* fs in featuredStores) {
        JOLImageSlide *slide = [[JOLImageSlide alloc] init];
        slide.title = fs.Name;
        slide.image = fs.ImageURL;
        slide.url = fs.AffiliateURL;
        [slideSet addObject:slide];
    }
    
    self.featuredBrandSlider.delegate = self;
    [self.featuredBrandSlider setAutoSlide: YES];
    [self.featuredBrandSlider setPlaceholderImage:@"placeholder.png"];
    [self.featuredBrandSlider setContentMode: UIViewContentModeScaleAspectFill];
    
    self.featuredBrandSlider.slideArray = slideSet;
    [self.featuredBrandSlider loadData];
}

- (void) createRecommendBar
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* stores = [Store getQuickStoresInLocationSync:[Global sharedGlobal].currentUser.Location.intValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for(UIView* _v in self.scrollRecommedBar.subviews)
                [_v removeFromSuperview];
            
            float x, y, w, h;
            x = 10;
            y = 0;
            w = 220;
            h = self.scrollRecommedBar.frame.size.height;
            
            for (Store* st in stores) {
                UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                imageview.contentMode = UIViewContentModeScaleAspectFit;

                [imageview setImageWithURL:[NSURL URLWithString:st.LogoURL] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [self refreshRecommendBar];
                }];
                
                imageview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
                
                [self.scrollRecommedBar addSubview:imageview];
                
                imageview.title = st.AffiliateURL;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
                [imageview addGestureRecognizer:tap];
                
                x += w + 10;
            }

            self.scrollRecommedBar.contentSize = CGSizeMake(x, 0);
            self.scrollRecommedBar.contentOffset = CGPointMake(0, 0);
            [self.view setNeedsLayout];
        });
    });
}

- (void) refreshRecommendBar
{
    float w = 1000;
    float h = self.scrollRecommedBar.frame.size.height;
    float x = 20 - 50;
    
    for(UIImageView* _v in self.scrollRecommedBar.subviews)
    {
        CGRect frame = _v.frame;

        if (_v.image != nil)
        {
            for (UIView* _isv in _v.subviews)
                [_isv removeFromSuperview];
            
            _v.backgroundColor = [UIColor clearColor];
            
            float iw = _v.image.size.width;
            float ih = _v.image.size.height;

            w = iw * h / ih;
            frame.size.width = w;
        }

        frame.origin.x = x + 50;
        _v.frame = frame;
        

        x = _v.frame.origin.x + _v.frame.size.width;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollRecommedBar.contentSize = CGSizeMake(x + 20, 0);
        self.scrollRecommedBar.contentOffset = CGPointMake(0, 0);
    });
}

- (void) createOfferView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* stores = [[Global sharedGlobal] getOfferStoreSync];
        
        for(UIView* _v in self.scrollOfferView.subviews)
            [_v removeFromSuperview];
        
        float x, y, w, h;
        x = 10;
        y = 0;
        w = self.scrollOfferView.frame.size.width;
        h = self.scrollOfferView.frame.size.height;
        
        for (FeaturedStore* ft in stores) {
            UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            [imageview setImageWithURL:[NSURL URLWithString:ft.ImageURL]];
            
            imageview.title = ft.AffiliateURL;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
            [imageview addGestureRecognizer:tap];
            
            [self.scrollOfferView addSubview:imageview];
            y += h + 5;
        }
        
        self.scrollOfferView.contentSize = CGSizeMake(0, y);
    });
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    NSString* url = gestureRecognizer.view.title;
    NSLog(@"Click Product Item : %@", url);
    
    if ([self.view.superview isKindOfClass:[SnsPageView class]])
    {
        SnsPageView* container = (SnsPageView*)self.view.superview;
        
        [container openURL:url];
    }
}

@end
