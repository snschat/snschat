//
//  ExQBChatDialog.m
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ExQBChatDialog.h"

@implementation QBChatDialog(Extension)
- (BOOL) isAccepted:(QBUUser *) user
{
    NSArray * array = self.data[@"accepted_users"];
    NSInteger idx;
    NSNumber * userID = [NSNumber numberWithInt: user.ID];
    
    if(![array isEqual: [NSNull null]])
    {
        
        for(idx = 0; idx < array.count; idx++)
        {
            if([array[idx] isEqualToNumber: userID])
                break;
        }
        if(idx == array.count)
        {
            idx = NSNotFound;
        }
    }
    else
        idx = NSNotFound;
    
    if(idx == NSNotFound)
    {
        return NO;
    }
    else
        return YES;
    
}
@end
