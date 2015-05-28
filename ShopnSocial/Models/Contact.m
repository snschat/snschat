//
//  Contact.m
//  ShopnSocial
//
//  Created by rock on 5/14/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Contact.h"

@implementation Contact
- (BOOL)isEqual:(id)object
{
    Contact * obj_contact = object;
    if(obj_contact.user == nil || self.user == nil)
        return FALSE;
    if(obj_contact.user.UserID == self.user.UserID)
        return TRUE;
    return FALSE;
    
}
@end
