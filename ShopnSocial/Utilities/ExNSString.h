//
//  ExNSString.h
//  ShopnSocial
//
//  Created by rock on 4/29/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (validation)

-(BOOL) isValidEmail;
-(BOOL) isValidPassword;

@end


@interface NSString (Crytation)

- (NSString *)MD5String;
- (NSString *) randomStringWithLength: (int) len;
@end

