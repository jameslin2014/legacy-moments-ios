//
//  AppDelegate.m
//  Moments
//
//  Created by Douglas Bumby on 2014-11-28.
//  Copyright (c) 2014 Cosmic. All rights reserved.
//

#import "MOAppDelegate.h"
#import "SSKeychain.h"
#import "MODecisionViewController.h"
#import "EDPagingViewController.h"
#import "MODecisionViewController.h"

@implementation MOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    // Initialise our S3 Singleton with our API credentials
    self.s3 = [MOS3APIUtilities sharedInstance];
    self.s3.accessKey = @"S3_ACCESSKEY";
    self.s3.secret = @"S3_SECRET";
    self.s3.bucket = @"S3_BUCKET";

    // Initialise our API Singleton with our API credentials
    self.api = [MomentsAPIUtilities sharedInstance];
    self.api.apiUrl = @"https://DOMAIN_NAME/api/users";
    self.api.apiUsername = @"API_USERNAME";
    self.api.apiPassword = @"API_PASSWORD";

    // Initialise our MOUser with values stored in the keychain
    self.api.user = [[MOUser alloc] init];

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"IntroHasBeenShown"]){
        if (self.api.user.loggedIn) {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateInitialViewController];
        } else {
            self.window.rootViewController = [[MODecisionViewController alloc] init];
        }
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IntroHasBeenShown"];
        self.window.rootViewController = [[EDPagingViewController alloc] init];
    }

    UVConfig *config = [UVConfig configWithSite:@"pickmoments.uservoice.com"];
    [config identifyUserWithEmail:[SSKeychain passwordForService:@"moments" account:@"username"] name:[SSKeychain passwordForService:@"moments" account:@"username"] guid:nil];
    [UVStyleSheet instance].preferredStatusBarStyle = UIStatusBarStyleDefault;
    [UserVoice initialize:config];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
