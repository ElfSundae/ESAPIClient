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

    [self setupAPIClient];

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:ViewController.new];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupAPIClient
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
    ESAPIClient *client = [[ESAPIClient alloc] initWithBaseURL:baseURL];
    client.requestSerializer.HTTPRequestHeadersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSURLRequest * _Nonnull request, id _Nullable parameters) {
        return @{ @"FooHeader": @"foo" };
    };
    client.requestSerializer.URLQueryParametersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSString * _Nonnull method, NSString * _Nonnull URLString, id _Nullable parameters) {
        return @{ @"_time": @((long)[NSDate date].timeIntervalSince1970) };
    };
#if DEBUG
    client.logger.enabled = YES;
    [client.logger setLogLevel:AFLoggerLevelDebug];
#endif

    ESAPIClient.defaultClient = client;
}

@end
