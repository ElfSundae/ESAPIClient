//
//  ESJSONResponseSerializer.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/09/10.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESJSONResponseSerializer.h"

@implementation ESJSONResponseSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.removesKeysWithNullValues = YES;
    }
    return self;
}

- (BOOL)validateResponseObject:(id)responseObject
{
    return YES;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSError *serializationError = nil;
    id responseObject = [super responseObjectForResponse:response
                                                    data:data
                                                   error:&serializationError];
    if (serializationError) {
        if (error) {
            *error = serializationError;
        }

        return nil;
    }

    if (responseObject && ![self validateResponseObject:responseObject]) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[NSLocalizedDescriptionKey] = NSLocalizedStringFromTable(@"Request failed: invalid response object", @"ESAPIClient", nil);
            userInfo[NSURLErrorFailingURLErrorKey] = response.URL;
            userInfo[AFNetworkingOperationFailingURLResponseErrorKey] = response;
            if (responseObject) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = responseObject;
            } else if (data) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = data;
            }
            *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain
                                         code:NSURLErrorCannotDecodeContentData
                                     userInfo:userInfo];
        }

        return nil;
    }

    return responseObject;
}

@end
