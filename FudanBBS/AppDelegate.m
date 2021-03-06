//
//  AppDelegate.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Ono.h"

#import "AppDelegate.h"
#import "VPTTopTenViewController.h"
#import "VPTBoardListViewController.h"
#import "VPTPersonalViewController.h"

#import "VPTNetworkService.h"
#import "VPTServiceManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [VPTServiceManager fetchAllBoards];
     
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UIViewController *ttvc = [VPTTopTenViewController new];
    UIViewController *bvc = [VPTBoardListViewController new];
    UIViewController *pvc = [VPTPersonalViewController new];
    
    [ttvc setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"今日十大" image:[UIImage imageNamed:@"icon_hot_unselected"] selectedImage:[UIImage imageNamed:@"icon_hot_selected"]]];
    [bvc setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"所有板块" image:[UIImage imageNamed:@"icon_directory"] selectedImage:[UIImage imageNamed:@"icon_directory"]]];
    [pvc setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"icon_person"] selectedImage:[UIImage imageNamed:@"icon_person"]]];
    [tabBarController setViewControllers:@[ttvc, bvc, pvc]];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:tabBarController]];
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

@end
