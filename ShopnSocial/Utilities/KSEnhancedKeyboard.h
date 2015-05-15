//
//  KSEnhancedKeyboard.h
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KSEnhancedKeyboardDelegate

- (void)nextDidTouchDown;
- (void)previousDidTouchDown;
- (void)doneDidTouchDown;

@end

@interface KSEnhancedKeyboard : NSObject

- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled;
@property (nonatomic, strong) id <KSEnhancedKeyboardDelegate> delegate;

@end
