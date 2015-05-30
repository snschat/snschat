//
//  BrowserHomeVC.m
//  ShopnSocial
//
//  Created by rock on 5/4/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "BrowserHomeVC.h"
#import "TabButton.h"
#import "UIImageView+WebCache.h"

#import "SnsPageView.h"
#import "SnsHomePageVC.h"
#import "SnsCategoryPageVC.h"
#import "CategoryPopoverVC.h"

#import "ExNSArray+Swap.h"

@interface BrowserHomeVC () <CategoryPopoverDelegate>

@end

@implementation BrowserHomeVC
{
    CategoryPopoverVC* popover;
    
    IBOutlet UITextField *addressText;

    // tab & pages
    SnsPageView* currentPage;
    NSMutableArray* tabPages;
    NSMutableArray* tabButtons;
}
-(void) viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *color = [UIColor blackColor];
    
    addressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:addressText.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    [addressText addTarget:self action:@selector(onChangeAddressText:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view bringSubviewToFront:self.laySearch];
    self.laySearch.hidden = YES;

    
    [self initTab];
    [self onHome:nil];
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

-(void)viewWillLayoutSubviews
{
    if (currentPage != nil) {
        currentPage.frame = self.mainview.bounds;
    }
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

#pragma mark - Tab Buttons

- (void) initTab
{
    tabPages = [NSMutableArray array];
    tabButtons = [NSMutableArray array];
}

- (void) addTabButton:(NSString*)title
{
    TabButton* button = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    button.backgroundColor = [UIColor colorWithRed:19 / 255.0f green:108 / 255.0f blue:164 / 255.0f alpha:1];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [button.CloseButton addTarget:self action:@selector(onTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabButtons addObject:button];
    
    [self updateTabBar];
}

- (void) setTabButtonTitleAt:(int)index title:(NSString*)title
{
    TabButton* button = [tabButtons objectAtIndex:index];
    [button setTitle:title forState:UIControlStateNormal];
    
    [self updateTabBar];
}

- (void) removeTabButtonAt:(int)index
{
    [tabButtons removeObjectAtIndex:index];
    [self updateTabBar];
}

- (void) updateTabBar
{
    for (UIView* view in self.layTabbar.subviews) {
        [view removeFromSuperview];
    }
    
    float x = 0;
    float h = self.layTabbar.frame.size.height;
    CGRect rt = CGRectZero;
    for (TabButton* tb in tabButtons) {
        [self.layTabbar addSubview:tb];
        
        [tb sizeToFit];
        
        float w = tb.frame.size.width + 70;
        if (tabButtons.count == 1)
            w = self.view.frame.size.width;
        else if (tabButtons.count == 2)
            w = self.view.frame.size.width / 2;
        //else w = self.view.frame.size.width / 2.5;
        tb.frame = CGRectMake(x, 0, w, h);

        if (tb.isSelected)
            rt = tb.frame;

        x = x + w;
    }
    
    self.layTabbar.contentSize = CGSizeMake(x, 0);
    
    CGPoint offset = self.layTabbar.contentOffset;
    if (rt.origin.x < offset.x)
        [self.layTabbar setContentOffset:rt.origin animated:YES];
    else if (rt.origin.x + rt.size.width > offset.x + self.layTabbar.frame.size.width)
        [self.layTabbar setContentOffset:
         CGPointMake(rt.origin.x + rt.size.width - self.layTabbar.frame.size.width, 0)
                                animated:YES];
        
}

- (void) selectTabButtonAt:(int)index
{
    CGRect rect;
    for (int i = 0; i < tabButtons.count; i++) {
        TabButton* tb = [tabButtons objectAtIndex:i];
        if (i == index) {
            [tb select:true];
            rect = tb.frame;
        }
        else
        {
            [tb select:false];
            if (i + 1 == index)
                tb.position = TabButtonPositionLeft;
            else if (i - 1 == index)
                tb.position = TabButtonPositionRight;
            else
                tb.position = TabButtonPositionMiddle;
        }
    }
    
    [self.layTabbar scrollRectToVisible:rect animated:true];
}

- (int) getIndexOfTabButton:(TabButton*)button
{
    return [tabButtons indexOfObject:button];
}

- (void)onTapButton:(id)sender {
    [self openTabPageAt:[self getIndexOfTabButton:(TabButton *)sender]];
}

- (void)onTapCloseButton:(id)sender {
    UIView* senderView = sender;
    [self closeTabPageAt:[self getIndexOfTabButton:(TabButton *)senderView.superview]];
}

#pragma mark - Tab Pages

- (void) addTabPage:(SnsPageView*)pageView
{
    [pageView addDelegate:self];
    
    [tabPages addObject:pageView];
    [self addTabButton:pageView.title];
}

- (void) openTabPageAt:(int)index;
{
    SnsPageView* page = [tabPages objectAtIndex:index];

    if (currentPage == page) return;
    
    if (currentPage != nil)
    {
        [currentPage removeFromSuperview];
    }
    
    currentPage = page;
    currentPage.frame = self.mainview.bounds;

    [self.mainview addSubview:currentPage];
    
    [self selectTabButtonAt:index];
}

- (void) closeTabPageAt:(int)index
{
    SnsPageView* page = [tabPages objectAtIndex:index];
    if (currentPage == page)
    {
        [self removeTabButtonAt:index];
        
        [currentPage removeFromSuperview];
        currentPage = nil;
    }
    
    [tabPages removeObject:page];
    
    int count = tabPages.count;
    if (count == 0) return;
    if (index < count)
        [self openTabPageAt:index];
    else
        [self openTabPageAt:index - 1];
}

#pragma mark - Tab Page Delegates

-(void)didSnsPageTitleChanged:(SnsPageView*)page title:(NSString*)title
{
    [self setTabButtonTitleAt:[tabPages indexOfObject:page] title:title];
}

-(void)didSnsPageNavigationChanged:(SnsPageView*)page
{
    [self updateNavigationBar:page];
}

-(void)didScrollDown:(SnsPageView*)page
{
    [self makeMiniNavigationBar];
}

-(void)didScrollReachedTop:(SnsPageView*)page
{
    [self makeFullNavigationBar];
}

#pragma mark - Navigator

- (void) makeFullNavigationBar
{
    if (self.view.frame.origin.y == 0) return;

    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(
                                 0,
                                 0,
                                 self.view.frame.size.width,
                                 [UIScreen mainScreen].bounds.size.height);
    [UIView commitAnimations];
}

- (void) makeMiniNavigationBar
{
    if (self.view.frame.origin.y < 0) return;
    
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(
                                 0,
                                 -self.topBar.frame.size.height,
                                 self.view.frame.size.width,
                                 [UIScreen mainScreen].bounds.size.height + self.topBar.frame.size.height);
    [UIView commitAnimations];
}

- (void) updateNavigationBar:(SnsPageView*)page
{
    NSURL* url = page.url;
    
    NSString* fullURL = url.absoluteString;
    
    if (url == nil || [fullURL rangeOfString:@"about:" options:NSAnchoredSearch].length > 0) {
        fullURL = @"";
        self.btnNavFavorite.alpha = 1.0f;
    }
    else
    {
        NSMutableArray* favorites = [NSMutableArray arrayWithArray:[Global sharedGlobal].FavoriteURLs];
        
        if ([favorites indexOfObject:url.absoluteString] == NSNotFound)
        {
            self.btnNavFavorite.alpha = 1.0f;
        }
        else
        {
            self.btnNavFavorite.alpha = 0.2f;
        }
    }
    
    addressText.text = fullURL;
}

- (IBAction)onBack:(id)sender {
    [currentPage goBack];
}

- (IBAction)onForward:(id)sender {
    [currentPage goForward];
}

- (IBAction)onHome:(id)sender {
    if (currentPage == nil) {
        [self addTabPage: [[SnsPageView alloc] init]];
        [self openTabPageAt:0];
    }
    [self loadHomePage];
}

- (IBAction)onFavorite:(id)sender {
    if (currentPage == nil) return;
    NSURL* url = currentPage.url;
    if (url == nil || [url.scheme isEqual:@"about"]) return;
    
    NSMutableArray* favorites = [NSMutableArray arrayWithArray:[Global sharedGlobal].FavoriteURLs];
    
    if ([favorites indexOfObject:url.absoluteString] != NSNotFound)
    {
        [favorites removeObject:url.absoluteString];
        [[Global sharedGlobal] setFavoriteURLs:favorites];
    }
    else
    {
        [favorites addObject:url.absoluteString];
        [[Global sharedGlobal] setFavoriteURLs:favorites];
    }
    
    [self updateNavigationBar:currentPage];
}

- (IBAction)onNewTab:(id)sender {
    //temp code    
    [self addTabPage: [[SnsPageView alloc] init]];
    [self openTabPageAt:tabPages.count - 1];
    [self loadHomePage];
}

- (IBAction)onRefresh:(id)sender {
    if (currentPage == nil) return;
    
    [currentPage refresh];
}
#pragma mark - Addressbar

- (void)onChangeAddressText:(id)sender
{
    [self searchProduct:addressText.text];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray* array = [[Global sharedGlobal] getGoogleSuggestionSync:addressText.text];
//        array = array;
//    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString* url = textField.text;
    
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])
    {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    [self openURL:url];
    
    return YES;
}

- (void)openURL:(NSString*)url
{
    if (currentPage == nil) {
        [self addTabPage: [[SnsPageView alloc] init]];
        [self openTabPageAt:0];
    }
    [currentPage openURL:url];
}

# pragma mark - search product table


- (void)searchProduct:(NSString*)keyword
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* stores = [Store getQuickStoresInLocationSync:[Global sharedGlobal].currentUser.Location.intValue keyword:keyword];
        
        stores = [stores sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Store* st1 = (Store*) obj1;
            Store* st2 = (Store*) obj2;
            
            NSRange searchRange1 = [st1.Retailer rangeOfString:keyword options:NSAnchoredSearch | NSCaseInsensitiveSearch];
            NSRange searchRange2 = [st2.Retailer rangeOfString:keyword options:NSAnchoredSearch | NSCaseInsensitiveSearch];
            
            if (searchRange1.length == searchRange2.length)
            {
                NSComparisonResult result = [st1.Retailer compare:st2.Retailer options:NSCaseInsensitiveSearch];
                return result;
            }
            else if (searchRange1.length > 0)
                return NSOrderedAscending;
            else
                return NSOrderedDescending;
            
        }];
        
        searchedProdcuts = stores;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.laySearch.hidden = NO;
            [self.searchTableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchedProdcuts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellview";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Store* st = [searchedProdcuts objectAtIndex:indexPath.row];
    
    UIView* layCotainer = [cell viewWithTag:200];
    UIImageView* imgLogo = (UIImageView*)[cell viewWithTag:201];
    UILabel* lblTitle = (UILabel*)[cell viewWithTag:202];
    UILabel* lblDescription = (UILabel*)[cell viewWithTag:203];
    
    imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    [imgLogo setImageWithURL:[NSURL URLWithString:st.LogoURL] placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    }];
    lblTitle.text = st.Retailer;
    lblDescription.text = st.Description;
    
    layCotainer.frame = CGRectMake(0, 0, tableView.frame.size.width, layCotainer.frame.size.height);
    
    [layCotainer setNeedsLayout];
    
    return cell;
}

- (IBAction)onSearchGoogle {
    NSString* googleURL = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", addressText.text];

    [addressText resignFirstResponder];
    self.laySearch.hidden = YES;
    [self openURL:googleURL];
}

- (IBAction)onTapOutsideOfSearchResult:(UITapGestureRecognizer *)sender {
    [addressText resignFirstResponder];
    self.laySearch.hidden = YES;
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
