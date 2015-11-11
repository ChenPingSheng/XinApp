//
//  AppDelegate.m
//  XinApp
//
//  Created by Kingyee on 15/10/23.
//  Copyright © 2015年 ChenXinApp. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CXWebsiteManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIApplicationShortcutItem *launchedShortcutItem;
@property (nonatomic, strong) MainViewController *mainViewCtrl;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rect];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.mainViewCtrl = mainVC;
    self.window.rootViewController = mainVC;
    
    [self.window makeKeyAndVisible];
    
    [application setMinimumBackgroundFetchInterval:3 * 60 * 60];
    
    BOOL shouldPerformAdditionalDelegateHandling = YES;
    
    // If a shortcut was launched, display its information and take the appropriate action
    UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    if (shortcutItem) {
        self.launchedShortcutItem = shortcutItem;
        // This will block "performActionForShortcutItem:completionHandler" from being called.
        shouldPerformAdditionalDelegateHandling = NO;
    }
    
//    return YES;
    return shouldPerformAdditionalDelegateHandling;
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
    if ([CXWebsiteManager websitesIsDifferent]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CXWebsiteListDidChangedNotification object:nil];
    }
    if (self.launchedShortcutItem) {
        [self handleShortcutItem:self.launchedShortcutItem];
        self.launchedShortcutItem = nil;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - handle shortcut

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    BOOL handledShortCutItem = [self handleShortcutItem:shortcutItem];
    completionHandler(handledShortCutItem);
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    NSString *shortcutType = [[shortcutItem.type componentsSeparatedByString:@"."] lastObject];
    NSInteger type = [shortcutType integerValue];
    self.mainViewCtrl.selectedIndex = type;
    
    return YES;
}

#pragma mark - Background Fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self.mainViewCtrl performFetchWithCompletionHandler:completionHandler];
}

@end
