//
//  Category.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Store.h"

#define QB_Class_Name @"Store"

@implementation Store

#pragma mark - class methods

+(NSArray*)getStoresInCategorySync:(ProductCategory*)cateogry
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"_parent_id": cateogry.customObject.ID,
                                                                                        @"limit": @(1000)
                                                                                        }];
    __block NSMutableArray* __stores;
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           __stores = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               Store* st = [[Store alloc] init];
                               st.customObject = co;
                               [__stores addObject:st];
                           }
                           
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           __stores = [NSMutableArray array];
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return __stores;
}

+(NSArray*)getQuickStoresInLocationSync:(int)locationCode
{
    NSArray* categories = [ProductCategory getCategoriesSync];
    NSString* targets = @"";
    
    for (ProductCategory* pc in categories) {
        if (pc.LocationCode != locationCode) continue;
        
        if (targets.length == 0)
            targets = [NSString stringWithFormat:@"%@", pc.customObject.ID];
        else
            targets = [NSString stringWithFormat:@"%@,%@", targets, pc.customObject.ID];
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"ParentID": targets,
                                                                                        @"IsQuickLink": @(YES),
                                                                                        @"limit": @(1000)
                                                                                        }];
    __block NSMutableArray* __stores;
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           __stores = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               Store* st = [[Store alloc] init];
                               st.customObject = co;
                               [__stores addObject:st];
                           }
                           
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           __stores = [NSMutableArray array];
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return __stores;
}

#pragma mark - properties

-(NSString*) Retailer
{
    return self.customObject.fields[@"Retailer"];
}

-(NSString*) LogoURL
{
    return self.customObject.fields[@"LogoUrl"];
}

-(NSString*) Description
{
    return self.customObject.fields[@"Description"];
}

-(NSString*) SiteURL
{
    return self.customObject.fields[@"SiteUrl"];
}

-(NSString*) AffiliateURL
{
    return self.customObject.fields[@"AffiliateUrl"];
}

-(BOOL) IsQuickLink
{
    NSNumber* value = self.customObject.fields[@"IsQuickLink"];
    return [value boolValue];
}

@end
