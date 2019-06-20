//
//  AppDelegate.m
//  iOS Example
//
//  Created by Elf Sundae on 2019/06/19.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:ViewController.new];

    [self.window makeKeyAndVisible];
    return YES;
}

@end
