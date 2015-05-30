//
//  ExQBChatDialog.h
//  ShopnSocial
//
//  Created by rock on 5/28/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Quickblox/Quickblox.h>

@interface QBChatDialog(Extension)
- (BOOL) isAccepted:(QBUUser *) user;
@end
