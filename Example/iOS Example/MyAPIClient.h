//
//  MyAPIClient.h
//  Example
//
//  Created by Elf Sundae on 2019/07/09.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <ESAPIClient/ESAPIClient.h>

#define APIClient [MyAPIClient defaultClient]

NS_ASSUME_NONNULL_BEGIN

@interface MyAPIClient : ESAPIClient

+ (instancetype)defaultClient;

@end

NS_ASSUME_NONNULL_END
