//
//  Category.m
//  ShopnSocial
//
//  Created by rock on 5/12/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "FeaturedStore.h"

#define QB_Class_Name @"FeaturedStore"

static NSMutableArray* categoires = nil;

@implementation FeaturedStore

#pragma mark - class methods

+(NSArray*)getStoresWithTypeSync:(NSString*)type inCountry:(int)locationCode
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                                                                        @"Type": type,
                                                                                        @"LocationCode" : [NSNumber numberWithInt:locationCode],
                                                                                        @"limit": @(1000)
                                                                                        }];
    __block NSMutableArray* __stores;
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           __stores = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               FeaturedStore* st = [[FeaturedStore alloc] init];
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

-(NSString*) Name
{
    return self.customObject.fields[@"Name"];
}

-(NSString*) ImageURL
{
    return self.customObject.fields[@"ImageUrl"];
}

-(NSString*) AffiliateURL
{
    return self.customObject.fields[@"AffiliateUrl"];
}

-(int) LocationCode
{
    NSNumber* value = self.customObject.fields[@"LocationCode"];
    return [value intValue];
}

@end
