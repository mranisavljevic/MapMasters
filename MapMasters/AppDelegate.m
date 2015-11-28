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
    LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [navController pushViewController:loginVC animated:YES];
    loginVC.completion = ^ {
        [navController popToRootViewControllerAnimated:YES];
    };
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
