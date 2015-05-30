//
//  ExNSArray+Swap.m
//  ShopnSocial
//
//  Created by rock on 5/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExNSArray+Swap.h"

static void *UIViewTitleKey;

@implementation NSMutableArray (swap)

-(void) swapFrom:(int)from to:(int)to
{
    id tempObj = [self objectAtIndex:from];
    [self replaceObjectAtIndex:from withObject:[self objectAtIndex:to]];
    [self replaceObjectAtIndex:to withObject:tempObj];
}

@end
