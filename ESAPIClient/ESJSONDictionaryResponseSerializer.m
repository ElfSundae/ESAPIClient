//
//  ESJSONDictionaryResponseSerializer.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESJSONDictionaryResponseSerializer.h"

@implementation ESJSONDictionaryResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *dict = [super responseObjectForResponse:response data:data error:error];

    // Check whether the response object is a NSDictionary object
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [self nc_serializationErrorWithCode:NSURLErrorCannotDecodeContentData
                                             description:NSLocalizedStringFromTable(@"Invalid response data", @"ESAPIClient", nil)
                                                response:response
                                            responseData:dict];
        }

        dict = nil;
    }

    return dict;
}

- (NSError *)nc_serializationErrorWithCode:(NSInteger)code
                               description:(NSString *)description
                                  response:(NSURLResponse *)response
                              responseData:(nullable id)responseData
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = description;
    userInfo[NSURLErrorFailingURLErrorKey] = response.URL;
    userInfo[AFNetworkingOperationFailingURLResponseErrorKey] = response;
    if (responseData) {
        userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = responseData;
    }

    return [NSError errorWithDomain:AFURLResponseSerializationErrorDomain
                               code:code
                           userInfo:userInfo];
}

@end
