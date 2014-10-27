//
//  ASAppDelegate.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMainMenu.h"

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	UINavigationController *rootNavigation = [[UINavigationController alloc] initWithRootViewController:[ASMainMenu new]];
	self.window.rootViewController = rootNavigation;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
