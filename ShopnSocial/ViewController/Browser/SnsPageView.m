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
    
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    webview.delegate = (id<UIWebViewDelegate>)self;
    [self addSubview:webview];
    
    //[webview stringByEvaluatingJavaScriptFromString:@"window.open('about:blank');"];
    
    historyPosition = 0;
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

#pragma mark - title

-(NSString*) title
{
    if (currentView == nil) return @"Sns page";
    NSString* t = currentView.title;
    if (t.length == 0) return @"Sns page";
    return t;
}

#pragma mark -

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
         
//        NSString* html = [NSString stringWithFormat:@"<html><body onload='goBackOrForwoard(%d);'></body><script  type='text/javascript'>var snsHistoryPosition = %d;</script></html>", historyPosition, historyPosition];
//        NSString* url = [NSString stringWithFormat:@"http://%d.sns.com.ios/pages", historyPosition];
//
//        NSLog(@"\n%@\n%@", url, html);
//        [webview loadHTMLString:html baseURL:[NSURL URLWithString:url]];
    }
    
    
    
//    historyPosition = [[webview stringByEvaluatingJavaScriptFromString:@"window.history.length"] intValue];
//
////    NSString* tempHTML = [NSString stringWithFormat:@"<html><head><title>temp html %d</title></head><body style='background:red;'>123123123</body></html>", historyPosition];
//    //[webview loadHTMLString:tempHTML baseURL:nil];
//    
////    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
////    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.bing.com"]]];
//    static int gidx = 0;
//    
//    if (gidx++ %2 == 0)
//        [webview stringByEvaluatingJavaScriptFromString:@"location.href='#snstop1';"];
//        //[webview stringByEvaluatingJavaScriptFromString:@"window.open('http://www.google.com')"];
//    else
//        [webview stringByEvaluatingJavaScriptFromString:@"location.href='#snstop2';"];
//        //[webview stringByEvaluatingJavaScriptFromString:@"window.open('http://www.bing.com')"];
//    
//    NSLog(@"%@", [webview stringByEvaluatingJavaScriptFromString:@"window.history.length"]);
//    historyPosition = [[webview stringByEvaluatingJavaScriptFromString:@"window.history.length"] intValue];
//    
    
    NSLog(@"%d", historyPosition);
    NSLog(@"%d", historyPosition);
}

-(void) _removeCurrentView
{
    if (currentView == nil) return;
    if (webview == currentView)
    {
        webview.frame = CGRectMake(0, 0, 500, 500);
    }
    else
        [currentView removeFromSuperview];
}

-(void) _addCurrentView
{
    if (currentView == nil) return;
    if (webview != currentView)
        [self addSubview:currentView];
    
    currentView.frame = self.bounds;
    
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
    
//    JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // Undocumented access
//    context[@"goBackOrForwoard"] = ^(NSNumber* number) {
//        [self goBackOrForwoard:number.intValue];
//    };
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // Undocumented access
//    context[@"goBackOrForwoard"] = ^(NSNumber* number) {
//        [self goBackOrForwoard:number.intValue];
//    };
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"web is loading or done %d, %@", webview.isLoading, [webview stringByEvaluatingJavaScriptFromString:@"location.href"]);

    if (webview.isLoading) return;
    
    NSString* url = [webview stringByEvaluatingJavaScriptFromString:@"location.href"];
    NSRange range = [url rangeOfString:@"snsios="];
    if (range.location == NSNotFound) return;
    
    NSString* historyPositionStr = [url substringFromIndex:range.location + range.length ];
    
    NSLog(@"snsHistoryPosition = %@", historyPositionStr);
    
    if (historyPositionStr.length == 0) return;
    
    [self goBackOrForwoard:[historyPositionStr intValue]];
    
    
//    JSContext *context =  [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; // Undocumented access
//    context[@"goBackOrForwoard"] = ^(NSNumber* number) {
//        [self goBackOrForwoard:number.intValue];
//    };
    
//    if (webview.isLoading) return;
//    
//    //if (webview == currentView)
//    {
//        [self pushView:webview];
//    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString* url = [webview stringByEvaluatingJavaScriptFromString:@"location.href"];
    NSRange range = [url rangeOfString:@"snsios="];
    if (range.location == NSNotFound) return;
    
    NSString* historyPositionStr = [url substringFromIndex:range.location + range.length ];
    
    NSLog(@"snsHistoryPosition = %@", historyPositionStr);
    
    if (historyPositionStr.length == 0) return;
    
    [self goBackOrForwoard:[historyPositionStr intValue]];
}

@end
