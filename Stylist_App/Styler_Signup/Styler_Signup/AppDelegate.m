//
//  AppDelegate.m
//  Styler_Signup
//
//  Created by Apple on 3/2/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>



@interface AppDelegate ()


@end
static NSString * const kClientID =
@"753613702057-cj10njpm174tr3bf6liebtt9e1203ks5.apps.googleusercontent.com";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [GIDSignIn sharedInstance].clientID = kClientID;
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    

    return [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions] ;
}
// remember to turn this off
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]
    || [[GIDSignIn sharedInstance]handleURL:url
                          sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                 annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
;

    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return  [[GIDSignIn sharedInstance]handleURL:url sourceApplication:sourceApplication annotation:annotation];
//    
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation]
        || [[GIDSignIn sharedInstance]handleURL:url sourceApplication:sourceApplication annotation:annotation];
    
}

- (void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
//    NSString*userID = user.userID;
//    NSString*IDToken = user.authentication.idToken;
//    NSString *name = user.profile.name;
//    NSString *email = user.profile.email;
    
}
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"Received error while fetching deferred app link %@", error);
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application will terminate");
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"implementing"];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
