//
//  SnsPageView.m
//  ShopnSocial
//
//  Created by rock on 5/15/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "SnsPageView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation SnsPageView
{
    UIWebView* webview;
    int historyPosition;
    
    NSMutableArray* delegates;
    
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
    delegates = [NSMutableArray array];
    
    viewStacks1 = [NSMutableArray array];
    viewStacks2 = [NSMutableArray array];
    
    currentView = nil;
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    webview.delegate = (id<UIWebViewDelegate>)self;
    webview.scrollView.delegate = (id<UIScrollViewDelegate>)self;
    [self addSubview:webview];
    
    //[webview stringByEvaluatingJavaScriptFromString:@"window.open('about:blank');"];
    
    historyPosition = 0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    currentView.frame = self.bounds;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.superview != currentView) return;
    
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    if (scrollView.contentOffset.y > 0)
    {
        // down scrolling
        [self fireScrollDown];
    }
    else if (scrollView.contentOffset.y <= 0)
    {
        // up scrolling but already reached to the top.
        [self fireScrollReachedTop];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"YES");
}

#pragma mark delegates

-(void) addDelegate:(id<SnsPageDelegate>) delegate
{
    [delegates addObject:delegate];
}

-(void) removeDelegate:(id<SnsPageDelegate>) delegate
{
    [delegates removeObject:delegate];
}

-(void) fireTitleChange:(NSString*)newTitle sender:(UIView*)sender;
{
    if (sender == self.topView)
        self.title = newTitle;
    
    for (id<SnsPageDelegate> _d in delegates) {
        if ([_d respondsToSelector:@selector(didSnsPageTitleChanged:title:)])
            [_d didSnsPageTitleChanged:self title:self.title];
    }
}

-(void) fireNavigationChanged
{
    for (id<SnsPageDelegate> _d in delegates) {
        if ([_d respondsToSelector:@selector(didSnsPageNavigationChanged:)])
            [_d didSnsPageNavigationChanged:self];
    }
}

-(void) fireScrollDown
{
    for (id<SnsPageDelegate> _d in delegates) {
        if ([_d respondsToSelector:@selector(didScrollDown:)])
            [_d didScrollDown:self];
    }
}

-(void) fireScrollReachedTop
{
    for (id<SnsPageDelegate> _d in delegates) {
        if ([_d respondsToSelector:@selector(didScrollReachedTop:)])
            [_d didScrollReachedTop:self];
    }
}


#pragma mark - title & url

-(NSString*) title
{
    if (currentView == nil) return @"Sns page";
    NSString* t = currentView.title;
    if (t.length == 0) return @"Sns page";
    return t;
}


#pragma mark -

-(void) refresh
{
    if (currentView == webview) {
        [webview reload];
    }
}

-(void) openURL:(NSString*)urlString
{
    NSURL *websiteUrl = [NSURL URLWithString:urlString];
    if (websiteUrl == nil) return;

    [self pushView:webview];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [webview loadRequest:urlRequest];
    
}

-(void) pushView:(UIView*)view
{
    if (currentView != nil)
    {
        [viewStacks1 addObject:currentView];

        if (currentView != view)
        {
            [self _removeCurrentView];
            currentView = view;
            [self _addCurrentView];
        }
    }
    else
    {
        currentView = view;
        [self _addCurrentView];
    }
    
    [viewStacks2 removeAllObjects];

    [self fireTitleChange:currentView.title sender:currentView];
    
    if (webview != currentView)
    {
        historyPosition = [viewStacks1 count];
        NSString* url = [NSString stringWithFormat:@"about:blank?snsios=%d",  historyPosition];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

-(void) _removeCurrentView
{
    if (currentView == nil) return;
    if (webview == currentView)
    {
        webview.frame = CGRectMake(0, 0, 1, 1);
    }
    else
        [currentView removeFromSuperview];
    
    if (currentView != webview)
    {
        UIView* view2000 = [currentView viewWithTag:2000];
        if (view2000 != nil && [view2000 isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view2000;
            scrollView.delegate = nil;
        }
    }
}

-(void) _addCurrentView
{
    if (currentView == nil) return;
    if (webview != currentView)
        [self addSubview:currentView];
    
    currentView.frame = self.bounds;

//    if (currentView != webview)
//    {
//        UIView* view2000 = [currentView viewWithTag:2000];
//        if (view2000 != nil && [view2000 isKindOfClass:[UIScrollView class]]) {
//            UIScrollView* scrollView = (UIScrollView*)view2000;
//            scrollView.delegate = (id<UIScrollViewDelegate>)self;
//        }
//    }

}

-(UIView*) topView
{
    return currentView;
}

-(void) goBack
{
    if (currentView != webview) [self _goBack];
    [webview goBack];
}

-(void) _goBack
{
    if (self.isEnableBack == NO) return;
    
    [viewStacks2 addObject:currentView];
    [self _removeCurrentView];
    currentView = [viewStacks1 lastObject];
    [viewStacks1 removeLastObject];
    
    [self _addCurrentView];
    [self fireTitleChange:currentView.title sender:currentView];
}

-(void) goForward
{
    if (currentView != webview) [self _goForward];
    [webview goForward];
}

-(void) _goForward
{
    if (self.isEnableForward == NO) return;
    
    NSLog(@"%@", currentView);
    
    [viewStacks1 addObject:currentView];
    [self _removeCurrentView];
    currentView = [viewStacks2 lastObject];
    [viewStacks2 removeLastObject];
    
    [self _addCurrentView];
    [self fireTitleChange:currentView.title sender:currentView];
}

-(BOOL) isEnableBack
{
    //return [webview canGoBack];
    return viewStacks1.count > 0;
}

-(BOOL) isEnableForward
{
    //return [webview canGoForward];
    return viewStacks2.count > 0;
}


#pragma web view delegate

- (void)goBackOrForwoard:(int)position
{
    NSLog(@"back history %d, current position %d", viewStacks1.count, position);
    
    if (viewStacks1.count == position) return;
    if (viewStacks1.count == position + 1)
        [self _goBack];
    else if(viewStacks1.count + 1 == position)
        
        [self _goForward];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"webview is starting %@", request.URL);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.url = webview.request.mainDocumentURL;
    [self fireNavigationChanged];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"web is loading or done %d, %@", webview.isLoading, [webview stringByEvaluatingJavaScriptFromString:@"location.href"]);

    self.url = webview.request.mainDocumentURL;
    [self fireNavigationChanged];

    if (webview.isLoading) return;
    
    
    if (webview == currentView)
    {
        webview.title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
        [self fireTitleChange:webview.title sender:webview];
    }
    
    NSString* url = [webview stringByEvaluatingJavaScriptFromString:@"location.href"];
    NSRange range = [url rangeOfString:@"snsios="];
    if (range.location == NSNotFound) return;
    
    NSString* historyPositionStr = [url substringFromIndex:range.location + range.length ];
    
    NSLog(@"snsHistoryPosition = %@", historyPositionStr);
    
    if (historyPositionStr.length == 0) return;
    
    [self goBackOrForwoard:[historyPositionStr intValue]];
}

@end
