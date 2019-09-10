//
//  ESJSONResponseSerializer.h
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/09/10.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A subclass of `AFJSONResponseSerializer` that removes keys with `NSNull`
 * values from the response JSON by default, supports validating the decoded
 * response object.
 */
@interface ESJSONResponseSerializer : AFJSONResponseSerializer

/**
 * Validates the decoded response object.
 */
- (BOOL)validateResponseObject:(nullable id)responseObject;

@end

NS_ASSUME_NONNULL_END
