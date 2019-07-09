//
//  MyAPIClient.m
//  Example
//
//  Created by Elf Sundae on 2019/07/09.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "MyAPIClient.h"

@implementation MyAPIClient

+ (instancetype)defaultClient
{
    static MyAPIClient *_defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
        _defaultClient = [[self alloc] initWithBaseURL:baseURL];

        _defaultClient.requestSerializer.HTTPRequestHeadersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSURLRequest * _Nonnull request, id _Nullable parameters) {
            return @{ @"FooHeader": @"foo" };
        };
        _defaultClient.requestSerializer.URLQueryParametersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSString * _Nonnull method, NSString * _Nonnull URLString, id _Nullable parameters) {
            return @{ @"_time": @((long)[NSDate date].timeIntervalSince1970) };
        };
#if DEBUG
        _defaultClient.logger.enabled = YES;
        [_defaultClient.logger setLogLevel:AFLoggerLevelDebug];
#endif
    });
    return _defaultClient;
}

@end
