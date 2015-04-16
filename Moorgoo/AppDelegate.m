//
//  AppDelegate.m
//  Moorgoo
//
//  Created by SI  on 2/27/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

NSMutableArray *allTutorFromParse;
NSMutableArray *allCourseFromParse;

@interface AppDelegate ()
- (void)networkChanged:(NSNotification *)notification;

@end

@implementation AppDelegate
@synthesize noInternetAlert;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:PARSE_APPLICATION_ID clientKey:PARSE_CLIENT_KEY];
    /********************************************************************************************************/
    allTutorFromParse = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"CollegeClassTutor"];
    [query setLimit:1000];
    [query includeKey:@"userId"];
    [query includeKey:@"departmentId"];
    [query includeKey:@"schoolId"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *object in objects) {
                PFUser *user = [object objectForKey:@"userId"];
                
                //Check whtether userId exists
                if(user != nil){
                    PFObject *department = [object objectForKey:@"departmentId"];
                    PFObject *school = [object objectForKey:@"schoolId"];
                    CollegeClassTutor *tutor = [[CollegeClassTutor alloc] init];
                    
                    tutor.firstName = [user objectForKey:@"firstName"];
                    tutor.lastName = [user objectForKey:@"lastName"];
                    tutor.phone = [user objectForKey:@"phone"];
                    tutor.email = [user objectForKey:@"email"];
                    tutor.userId = user.objectId;
                    tutor.courses = [object objectForKey:@"courses"];
                    tutor.AClasses = [object objectForKey:@"AClasses"];
                    tutor.availableDays = [object objectForKey:@"availableDays"];
                    tutor.price = ([object objectForKey:@"price"] == nil) ? @"" : [object objectForKey:@"price"];
                    tutor.department = (department == nil) ? @"" : [department objectForKey:@"department"];
                    tutor.school = (school == nil) ? @"" : [school objectForKey:@"schoolName"];
                    tutor.schoolAbbreviation = ([object objectForKey:@"schoolAbbreviation"] == nil) ? @"" : [object objectForKey:@"schoolAbbreviation"];
                    tutor.goodRating = ([object objectForKey:@"goodRating"] == nil) ? @"" : [object objectForKey:@"goodRating"];
                    tutor.badRating = ([object objectForKey:@"badRating"] == nil) ? @"" : [object objectForKey:@"badRating"];
                    tutor.selfAd = ([object objectForKey:@"selfAd"] == nil) ? @"" : [object objectForKey:@"selfAd"];
                    
                    
                    /**************************************************************************************/
                    [[user objectForKey:@"profilePicture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        tutor.profileImage = [UIImage imageWithData:data];
                        [allTutorFromParse addObject:tutor];
                    }];
                    /**************************************************************************************/
                }
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    /********************************************************************************************************/
    allCourseFromParse = [[NSMutableArray alloc] init];
    PFQuery *theQuery = [PFQuery queryWithClassName:@"Course"];
    [theQuery setLimit:1000];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            allCourseFromParse = [objects valueForKey:@"courseName"];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
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
