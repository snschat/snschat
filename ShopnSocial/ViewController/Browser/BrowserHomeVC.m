//
//  BrowserHomeVC.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "BrowserHomeVC.h"

#import "SnsPageView.h"
#import "SnsHomePageVC.h"
#import "SnsCategoryPageVC.h"
#import "CategoryPopoverVC.h"

@interface BrowserHomeVC () <CategoryPopoverDelegate>

@end

@implementation BrowserHomeVC
{
    SnsPageView* currentPage;
    CategoryPopoverVC* popover;
    
    IBOutlet UITextField *addressText;
    
    NSMutableArray* tabPages;
}
-(void) viewDidLoad
{
    currentPage = [[SnsPageView alloc] init];
    currentPage.frame = self.mainview.bounds;
    [self.mainview addSubview:currentPage];
    
    
    [self loadHomePage];

    UIColor *color = [UIColor blackColor];
    
    addressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:addressText.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    [addressText addTarget:self action:@selector(onChangeAddressText:) forControlEvents:UIControlEventEditingChanged];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self loadHomePage];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"listpopover"])
    {
        if (popover == nil)
        {
            popover = (CategoryPopoverVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"CategoryPopoverVC"];
            
            popover.delegate = self;
        }

        UIView* popview = [[UIView alloc] initWithFrame:self.view.bounds];
        popview.backgroundColor = [UIColor clearColor];
        
        UIView* backview = [[UIView alloc] initWithFrame:self.view.bounds];
        backview.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:popview];
        [popview addSubview:backview];
        [popview addSubview:popover.view];
        
        
        UIView* anchor = sender;
        CGRect anchorRect = [anchor convertRect:anchor.bounds toView:self.view];
        
        CGRect frame = popover.view.frame;
        frame.origin.x = anchorRect.origin.x;
        frame.origin.y = anchorRect.origin.y + anchorRect.size.height;
        frame.size.width = anchorRect.size.width;
        frame.size.height = 300;
        popover.view.frame = frame;
        
        UITapGestureRecognizer* tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPopoverBackground:)];
        [backview addGestureRecognizer:tapgesture];
        
        return NO;
    }
    return YES;
}

-(void)onTapCategory:(ProductCategory*)category
{
    NSLog(@"%@", category);
    
    [self onTapPopoverBackground:nil];
    [self loadCategoryPageWithCategory:category];
}

- (void)onTapPopoverBackground:(UITapGestureRecognizer*)gesture
{
    if (gesture != nil)
    {
        CGPoint point = [gesture locationInView:popover.view];
        CGRect frame = popover.view.bounds;
        
        if (CGRectContainsPoint(frame, point)) return;
    }

    UIView* popoverContainer = popover.view.superview;
    
    [popoverContainer removeFromSuperview];
    popover = nil;
}

#pragma mark - Navigator

- (IBAction)onBack:(id)sender {
    [currentPage goBack];
}

- (IBAction)onForward:(id)sender {
    [currentPage goForward];
}

- (IBAction)onHome:(id)sender {
    [self loadHomePage];
}

- (IBAction)onFavorite:(id)sender {
}

- (IBAction)onNewTab:(id)sender {
}

#pragma mark - Addressbar

- (void)onChangeAddressText:(id)sender
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray* array = [[Global sharedGlobal] getGoogleSuggestionSync:addressText.text];
//        array = array;
//    });
}


#pragma mark - Shopnsocial Home Page

- (void)loadCategoryPageWithCategory:(ProductCategory*)category
{
    static SnsCategoryPageVC* categoryVC;
    
    categoryVC = (SnsCategoryPageVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SnsCategoryPageVC"];
    
    categoryVC.cateogry = category;

    [currentPage pushView:categoryVC.view];
}

- (void)loadHomePage
{
    static SnsHomePageVC* homepageVC;
    
    homepageVC = (SnsHomePageVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"SnsHomePageVC"];

    [currentPage pushView:homepageVC.view];

}

#pragma mark -

- (IBAction)onSlideUp:(id)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [UIView animateWithDuration:0.75
//                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [self.navigationController pushViewController:vc animated:NO];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
//                     }];
}


- (IBAction)onTouchSliderButton {

    if (self.chatbar.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             CGRect frame = self.chatbar.frame;
                             frame.origin.x = -frame.size.width;
                             self.chatbar.frame = frame;
                         } completion:^(BOOL finished) {
                             [self.buttonChatSlider setImage:[UIImage imageNamed:@"button_blue_right"] forState:UIControlStateNormal];
                         }
         ];
    }
    else if (self.chatbar.frame.origin.x == -self.chatbar.frame.size.width) {
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = self.chatbar.frame;
                             frame.origin.x = 0;
                             self.chatbar.frame = frame;
                         } completion:^(BOOL finished) {
                             [self.buttonChatSlider setImage:[UIImage imageNamed:@"button_blue_left"] forState:UIControlStateNormal];
                         }
         ];
    }
}

@end
