//
//  Country.m
//  ShopnSocial
//
//  Created by rock on 4/30/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Country.h"

#define QB_Class_Name @"Country"

static NSMutableArray* gCountries = nil;
static NSMutableDictionary* gDicCountries = nil;

@implementation Country

+(NSArray*)getCountriesSync
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    if (gCountries != nil || gCountries.count != 0)
    {
        return gCountries;
    }
    
    NSMutableDictionary * getRequest = [NSMutableDictionary dictionaryWithDictionary: @{
                                  @"sort_asc": @"code",
                                  @"limit": @(1000)
                                  }];
    
    [QBRequest objectsWithClassName:QB_Class_Name
                    extendedRequest:getRequest
                       successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
                           if (gCountries == nil)
                               gCountries = [NSMutableArray array];
                           
                           for (QBCOCustomObject* co in objects) {
                               Country* entry = [[Country alloc] init];
                               entry.customObject = co;
                               entry.Code = co.fields[@"code"];
                               entry.Name = co.fields[@"name"];
                               [gCountries addObject:entry];
                           }
                           
                           dispatch_semaphore_signal(sema);
                       } errorBlock:^(QBResponse *response) {
                           NSLog(@"Response error: %@", [response.error description]);
                           gCountries = [NSMutableArray array];
                           dispatch_semaphore_signal(sema);
                       }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return gCountries;
}

+(NSDictionary*)getCountryDictionarySync
{
    if (gDicCountries != nil) return gDicCountries;
    
    [self getCountriesSync];
    
    gDicCountries = [NSMutableDictionary dictionary];
    
    for (Country* co in gCountries) {
        [gDicCountries setObject:co forKey:co.Code];
    }
    
    return gDicCountries;
}

@end
