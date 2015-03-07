//
//  AppDelegate.m
//  Moorgoo
//
//  Created by SI  on 2/27/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()
- (void)networkChanged:(NSNotification *)notification;

@end

@implementation AppDelegate
@synthesize noInternetAlert;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_KEY];
    
    /********************************************************************************************************/
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeychainTest" accessGroup:nil];
    [keychain setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    keychain = nil;
    
    BOOL isLoggedIn = (![username isEqualToString:@""]) && (![password isEqualToString:@""]);
    
    NSString *storyboardId = isLoggedIn ? @"MainIdentifier" : @"LoginIdentifier";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initViewController;
    [self.window makeKeyAndVisible];
    /********************************************************************************************************/
    noInternetAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet Connection!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        NSLog(@"not reachable at appdelegate");
        [noInternetAlert show];
    }
    
    [reachability startNotifier];
    /******************************************************************************/
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
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

- (void)networkChanged:(NSNotification *)notification{
    Reachability * reachability = [notification object];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        [noInternetAlert show];
    }
    else{
        [noInternetAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
}
@end
