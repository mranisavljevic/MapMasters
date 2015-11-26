//
//  AppDelegate.m
//  MapMasters
//
//  Created by Miles Ranisavljevic on 11/23/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"09b0698YNB51nOBuLTxOG1xRDtjVs2PmXZMGJqOM"
                  clientKey:@"F1vcVsUwJbw1qhdIZQvxOGnWtM0UVFSfzeUyk2LN"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self setUpLocalNotifications];
    if (![PFUser currentUser]) {
        [self presentLoginSignupViewController];
    }
    return YES;
}

- (void)presentLoginSignupViewController {
    UINavigationController *navController = (UINavigationController *)[[self window] rootViewController];
    UIStoryboard *storyboard = [navController storyboard];
    MapViewController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [homeVC addChildViewController:loginVC];
    [homeVC.view addSubview:loginVC.view];
    [loginVC didMoveToParentViewController:homeVC];
    __weak typeof(LoginViewController) *weakLoginVC = loginVC;
    loginVC.completion = ^ {
        __strong typeof(LoginViewController) *strongLoginVC = weakLoginVC;
        [strongLoginVC.view removeFromSuperview];
        [strongLoginVC removeFromParentViewController];
    };
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"You're here!" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    MapViewController *mapViewController = [[MapViewController alloc] init];
    [mapViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)setUpLocalNotifications {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

@end
