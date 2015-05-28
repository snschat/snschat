//
//  SnsPageView.h
//  ShopnSocial
//
//  Created by rock on 5/15/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExUIView+Title.h"

@class SnsPageView;

@protocol SnsPageDelegate <NSObject, UIWebViewDelegate>

@optional

-(void)didSnsPageTitleChanged:(SnsPageView*)page title:(NSString*)title;

-(void)didSnsPageNavigationChanged:(SnsPageView*)page;

@end

@interface SnsPageView : UIView

-(void) openURL:(NSString*)url;

-(void) pushView:(UIView*)view;
-(UIView*) topView;

-(void) goBack;
-(void) goForward;

-(BOOL) isEnableBack;
-(BOOL) isEnableForward;

-(NSString*) title;
-(void) setTitle:(NSString*) title;

/* WebFrameLoadDelegate method */
//- (void)webView:(UIWebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject;

#pragma mark - events

-(void) addDelegate:(id<SnsPageDelegate>) delegate;
-(void) removeDelegate:(id<SnsPageDelegate>) delegate;

-(void) fireTitleChange:(NSString*)newTitle sender:(UIView*)sender;

@end
