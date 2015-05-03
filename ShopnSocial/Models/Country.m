//
//  Country.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Country.h"

#define QB_Class_Name @"Country"

static NSMutableArray* countries = nil;

@implementation Country

+(NSArray*)getCountriesSync//:(void (^)(NSArray *countries))successBlock errorBlock:(void (^)())errorBlock
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    if (countries != nil || countries.count != 0)
    {
        return countries;
    }
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                  @"sort_asc": @"code",
                                  @"limit": @(1000)
                                  }];
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           if (countries == nil)
                               countries = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               Country* entry = [[Country alloc] init];
                               entry.customObject = co;
                               entry.Code = co.fields[@"code"];
                               entry.Name = co.fields[@"name"];
                               [countries addObject:entry];
                           }
                           
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           countries = [NSMutableArray array];
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return countries;
}

@end
