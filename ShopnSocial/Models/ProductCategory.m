//
//  Category.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ProductCategory.h"

#define QB_Class_Name @"Category"

static NSMutableArray* categoires = nil;

@implementation ProductCategory

#pragma mark - class methods

+(NSArray*)getCategoriesSync
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    if (categoires != nil || categoires.count != 0)
    {
        return categoires;
    }
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"sort_asc": @"LocationCode",
                                                                                        @"limit": @(1000)
                                                                                        }];
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           if (categoires == nil)
                               categoires = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               ProductCategory* pc = [[ProductCategory alloc] init];
                               pc.customObject = co;
                               [categoires addObject:pc];
                           }
                           
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           categoires = [NSMutableArray array];
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return categoires;
}

#pragma mark - properties

-(NSString*) Name
{
    return self.customObject.fields[@"Name"];
}

-(void)setName:(NSString *)Name
{
    [self.customObject.fields setObject:Name forKey:@"Name"];
}

-(int)LocationCode
{
    NSNumber* code = self.customObject.fields[@"LocationCode"];
    return code.intValue;
}

-(void)setLocationCode:(int)LocationCode
{
    [self.customObject.fields setValue:[NSNumber numberWithInt:LocationCode] forKey:@"LocationCode"];
}

@end
