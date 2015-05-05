//
//  ExUILabel+AutoSize.m
//  ShopnSocial
//
//  Created by rock on 4/22/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExUILabel+AutoSize.h"

@implementation UILabel (dynamicSizeMe)

- (float) fitHeight
{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

- (float) expectedHeight
{
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize expectedSize = CGSizeMake(self.frame.size.width, FLT_MAX);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.font, NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributesDictionary];
    
    CGRect calculatedSize = [string boundingRectWithSize:expectedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return calculatedSize.size.height;

}

+(float) expectedHeight:(CGFloat) width :(UIFont *) font :(NSString *)text
{
    
    CGSize expectedSize = CGSizeMake(width, FLT_MAX);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          
                                          nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    
    CGRect calculatedSize = [string boundingRectWithSize:expectedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return calculatedSize.size.height;

}
@end