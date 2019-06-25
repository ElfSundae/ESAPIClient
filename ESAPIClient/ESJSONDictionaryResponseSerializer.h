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

/**
 * The "code" key in the response dictionary.
 * @discussion If `responseCodeKey` is not nil, the serializer will check whether
 * the code exists in the response dictionary. If no code found, the serializer
 * will return failure with error.
 */
@property (nullable, nonatomic, copy) NSString *responseCodeKey;

#pragma mark - Subclassing

/**
 * Determines the response object is valid.
 */
- (BOOL)validateResponseObject:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
