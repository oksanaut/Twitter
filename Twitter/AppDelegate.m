//
//  AppDelegate.m
//  Twitter
//
//  Created by Oksana Timonin on 28/10/2014.
//  Copyright (c) 2014 oksanaut. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "NavigationViewController.h"
#import "TwitterClient.h"
#import "Person.h"
#import "Story.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin) name:UserAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogout) name:UserRemovedNotification object:nil];
    
    Person *user = [Person user];
    if (user != nil) {
        NSLog(@"User is logged in as %@", user.name);
        NavigationViewController *vc = [[NavigationViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nvc;
//        HomeViewController *vc = [[HomeViewController alloc] init];
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
//        self.window.rootViewController = nvc;
    } else {
        NSLog(@"User is not logged in");
        LoginViewController *lvc = [[LoginViewController alloc] init];
        self.window.rootViewController = lvc;
    }
    
    [self.window makeKeyAndVisible];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] openURL:url];
    return YES;
}

- (void)handleLogin {
    HomeViewController *vc = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nvc;
}

- (void)handleLogout {
    NSLog(@"User is not logged in");
    LoginViewController *lvc = [[LoginViewController alloc] init];
    self.window.rootViewController = lvc;
}

@end
