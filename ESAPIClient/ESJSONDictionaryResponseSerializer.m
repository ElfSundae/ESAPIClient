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

- (BOOL)validateResponseObject:(nullable id)object
{
    return ([object isKindOfClass:[NSDictionary class]] &&
            (!self.responseCodeKey || [(NSDictionary *)object objectForKey:self.responseCodeKey]));
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSError *serializerError = nil;
    id object = [super responseObjectForResponse:response data:data error:&serializerError];

    if (serializerError) {
        if (error) {
            *error = serializerError;
        }

        return nil;
    }

    if (![self validateResponseObject:object]) {
        if (error) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[NSLocalizedDescriptionKey] = NSLocalizedStringFromTable(@"Invalid response object", @"ESAPIClient", nil);
            userInfo[NSURLErrorFailingURLErrorKey] = response.URL;
            userInfo[AFNetworkingOperationFailingURLResponseErrorKey] = response;
            if (object) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = object;
            } else if (data) {
                userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] = data;
            }

            *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain
                                         code:NSURLErrorCannotDecodeContentData
                                     userInfo:userInfo];
        }

        return nil;
    }

    return object;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.responseCodeKey = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(responseCodeKey))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];

    [coder encodeObject:self.responseCodeKey forKey:NSStringFromSelector(@selector(responseCodeKey))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ESJSONDictionaryResponseSerializer *serializer = [super copyWithZone:zone];

    serializer.responseCodeKey = [self.responseCodeKey copyWithZone:zone];

    return serializer;
}

@end
