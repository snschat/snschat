//
//  ExUILabel+AutoSize.h
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (dynamicSizeMe)

- (float) fitHeight;
- (float) expectedHeight;
+(float) expectedHeight:(CGFloat) width :(UIFont *) font :(NSString *)text;
@end
