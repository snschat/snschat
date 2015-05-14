//
//  AppDelegate.m
//  ShopnSocial
//
//  Created by rock on 4/21/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "AppDelegate.h"
#import "Chat.h"
#import "FHSTwitterEngine.h"
#import "Constants.h"

#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#define kGooglePlus_ClientID @"628383322351-d262hkc40d39ak30rme31rl48gj7hct4.apps.googleusercontent.com"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Facebook. Look FB Setting in Info.plist file.
    [FBProfilePictureView class];
    [FBLoginView class];
    
    // G++.
    [GPPSignIn sharedInstance].clientID = kGooglePlus_ClientID;
    [GPPSignIn sharedInstance].scopes = @[ kGTLAuthScopePlusLogin ];
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    
    // Set QuickBlox credentials
    [QBApplication sharedApplication].applicationId = 20591;
    [QBConnection registerServiceKey:@"GzNLC8xOCnAzsLD"];
    [QBConnection registerServiceSecret:@"6Ar4uFu7q5hZ75E"];
    [QBSettings setAccountKey:@"4pwY7nU5yidFJm6zAxaL"];
    
    
    //Twitter
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:TwitterConsumerKey andSecret:TwitterConsumerSecret];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if([Chat isLoggedIn])
        [Chat logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Chat loginToChat];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if([Chat isLoggedIn])
        [Chat logout];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled;
    
    // FB handles URL.
    wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];

    if (wasHandled) return wasHandled;
    
    // G++ handles URL
    wasHandled = [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return wasHandled;
}


#pragma mark -

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
    
}

@end
