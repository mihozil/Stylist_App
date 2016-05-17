//
//  AppDelegate.m
//  Stylist_App
//
//  Created by Apple on 4/21/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "AppDelegate.h"
#import "RoomSingleton.h"
#import <Firebase/Firebase.h>
#import "UIAlertController+Window.h"


@interface AppDelegate ()

@end

@implementation AppDelegate{
    Firebase *roomRef;
}

- (void) registerLocalNotification{
    UIUserNotificationType notificationType = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:nil];
    [[UIApplication sharedApplication]registerUserNotificationSettings:notificationSettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerLocalNotification];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([application applicationState] == UIApplicationStateActive){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Request received" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
            
        }];
        [alertController addAction:action];
        [alertController show];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    roomRef = [[RoomSingleton shareSingleton]roomRef];
    [roomRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        NSDictionary *dic = snapShot.value;
        NSString *status  = dic[@"status"][@"status1"];
        
        if ([status isEqualToString:@"open"]){
            [roomRef removeValue];
        }else if ([status isEqualToString:@"waiting"]){
            [[[roomRef childByAppendingPath:@"status"]childByAppendingPath:@"status1"]setValue:@"reject"];
        };
    }];
}


@end
