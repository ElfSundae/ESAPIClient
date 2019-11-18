//
//  ESJSONResponseSerializer.h
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/09/10.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESJSONResponseSerializer : AFJSONResponseSerializer

/**
 * Whether to remove keys with `NSNull` values from response JSON.
 * @discussion Defaults to \c YES .
 */
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

/**
 * Validates the decoded response object.
 */
- (BOOL)validateResponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
