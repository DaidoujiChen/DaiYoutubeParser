//
//  AppDelegate.m
//  DaiYoutubeParser
//
//  Created by DaidoujiChen on 2015/10/2.
//  Copyright © 2015年 DaidoujiChen. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [DemoViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
