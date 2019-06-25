//
//  ESJSONDictionaryResponseSerializer.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESJSONDictionaryResponseSerializer.h"

@implementation ESJSONDictionaryResponseSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.removesKeysWithNullValues = YES;
        self.acceptableContentTypes =
            [self.acceptableContentTypes setByAddingObjectsFromArray:
             @[ @"text/html", @"text/plain" ]];
    }
    return self;
}

- (BOOL)validateResponseDictionary:(NSDictionary *)dictionary
                          response:(NSURLResponse *)response
                      responseData:(NSData *)responseData
                             error:(NSError *__autoreleasing *)error
{
    if (
        !dictionary ||
        ![dictionary isKindOfClass:[NSDictionary class]] ||
        (self.responseCodeKey && !dictionary[self.responseCodeKey])
    ) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[NSLocalizedDescriptionKey] = NSLocalizedStringFromTable(@"Invalid response data", @"ESAPIClient", nil);
            userInfo[NSURLErrorFailingURLErrorKey] = response.URL;
            userInfo[AFNetworkingOperationFailingURLResponseErrorKey] = response;
            if (dictionary) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = dictionary;
            } else if (responseData) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = responseData;
            }

            *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain
                                         code:NSURLErrorCannotDecodeContentData
                                     userInfo:userInfo];
        }

        return NO;
    }

    return YES;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *dictionary = [super responseObjectForResponse:response data:data error:error];

    if (dictionary && ![self validateResponseDictionary:dictionary response:response responseData:data error:error]) {
        return nil;
    }

    return dictionary;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    ESJSONDictionaryResponseSerializer *serializer = [super copyWithZone:zone];

    serializer.responseCodeKey = [self.responseCodeKey copyWithZone:zone];

    return serializer;
}

@end
