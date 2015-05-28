//
//  ExUIView+Title.m
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExUIView+Title.h"
#import <objc/runtime.h>

static void *UIViewTitleKey;

@implementation UIView (exTitle)

-(NSString*) title
{
    NSString *result = objc_getAssociatedObject(self, &UIViewTitleKey);
    if (result == nil) {
        result = @"";
        objc_setAssociatedObject(self, &UIViewTitleKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

-(void) setTitle:(NSString*) title
{
    NSString *result = objc_getAssociatedObject(self, &UIViewTitleKey);
    if (result == nil) {
        result = title;
        objc_setAssociatedObject(self, &UIViewTitleKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
