//
//  ShopnSocialTests.m
//  ShopnSocialTests
//
//  Created by rock on 4/21/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ExNSString.h"
#import "ExNSDate.h"

#import "User.h"
#import <Quickblox/Quickblox.h>
#import "FBEncryptorAES.h"

@interface ShopnSocialTests : XCTestCase

@end

@implementation ShopnSocialTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testStringTrim {
    NSString* username = @"x@hotmail.com";
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    XCTAssert(username.isValidEmail, "Opps!");
}

- (void)testNSDate {
    NSDate* date = [NSDate date];
    NSString* string = [date stringWithFormat:@"MMMM d, yyyy"];
    
    NSLog(@"%@", string);
    
    XCTAssert(true, @"Oh yeah");
}

- (void)testQB {
    // Set QuickBlox credentials
    [QBApplication sharedApplication].applicationId = 20591;
    [QBConnection registerServiceKey:@"GzNLC8xOCnAzsLD"];
    [QBConnection registerServiceSecret:@"6Ar4uFu7q5hZ75E"];
    [QBSettings setAccountKey:@"4pwY7nU5yidFJm6zAxaL"];
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = @"mazb19";
    parameters.userPassword = @"evoodioz";
    
    [QBRequest createSessionWithExtendedParameters:parameters
                                      successBlock:^(QBResponse *response, QBASession *session) {
                                          NSLog(@"Session created");
                                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                              User* user = [User getUserByNameSync:@"mirro"];
                                              NSLog(@"%@", user);
                                          });
                                      } errorBlock:^(QBResponse *response) {
                                          NSLog(@"Session create failed");
                                      }];
    
    sleep(10000);
    
    XCTAssert(true, @"Oh yeah");
}

- (void)testAESEncrypt
{
    NSString* planText = @"Hello";
    NSString* key = @"key";
    
    NSString* encrypted = [FBEncryptorAES encryptBase64String:planText
                                                    keyString:key
                                                separateLines:NO];
    
    NSLog(@"encrypted string : %@", encrypted);
    
    NSString* decrypted = [FBEncryptorAES decryptBase64String:encrypted keyString:key];
    
    NSLog(@"decrypted string: %@", decrypted);
    
    XCTAssert([planText isEqualToString:decrypted], @"Oh yeah");
}
@end
