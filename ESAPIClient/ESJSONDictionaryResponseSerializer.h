//
//  ESJSONDictionaryResponseSerializer.h
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A subclass of `AFJSONResponseSerializer` that only accept NSDictionary as
 * the decoded response object.
 */
@interface ESJSONDictionaryResponseSerializer : AFJSONResponseSerializer

@end

NS_ASSUME_NONNULL_END
