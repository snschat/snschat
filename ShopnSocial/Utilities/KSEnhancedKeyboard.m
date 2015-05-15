//
//  KSEnhancedKeyboard.m
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "KSEnhancedKeyboard.h"

@implementation KSEnhancedKeyboard
- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    

    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(doneDidClick:)];

    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}

- (void)nextPrevHandlerDidChange:(id)sender
{
    if (!self.delegate) return;
    
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            NSLog(@"Previous");
            [self.delegate previousDidTouchDown];
            break;
        case 1:
            NSLog(@"Next");
            [self.delegate nextDidTouchDown];
            break;
        default:
            break;
    }
}

- (void)doneDidClick:(id)sender
{
    if (!self.delegate) return;
    
    NSLog(@"Done");
    [self.delegate doneDidTouchDown];
}

@end
