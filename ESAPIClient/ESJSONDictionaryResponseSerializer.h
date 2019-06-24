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
 * @discussion If `responseCodeKey` is not nil, the serializer will parse the
 * response dictionary to check whether the code in dictionary equals
 * `responseSuccessCode`, if they are not equal, the serializer will return
 * failure with error.
 */
@property (nullable, nonatomic, copy) NSString *responseCodeKey;

/**
 * The code value of success in the response dictionary.
 */
@property (nonatomic) NSInteger responseSuccessCode;

/**
 * The "message" key in the response dictionary.
 * @discussion When the serializer fails as the "code" in the response dictionary
 * is not equal the `responseSuccessCode`, the serializer can parse the message
 * and show it in a HUD view on iOS.
 */
@property (nullable, nonatomic, copy) NSString *responseMessageKey;

@end

NS_ASSUME_NONNULL_END
