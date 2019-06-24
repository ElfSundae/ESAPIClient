//
//  ESJSONDictionaryResponseSerializer.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESJSONDictionaryResponseSerializer.h"
#import <ESFramework/ESHelpers.h>
#if TARGET_OS_IOS
#import <MBProgressHUD/MBProgressHUD.h>
#endif

ESDefineAssociatedObjectKey(responseCodeKey)
ESDefineAssociatedObjectKey(responseSuccessCode)
ESDefineAssociatedObjectKey(responseMessageKey)

@implementation ESJSONDictionaryResponseSerializer

- (NSString *)responseCodeKey
{
    return objc_getAssociatedObject(self, responseCodeKeyKey);
}

- (void)setResponseCodeKey:(NSString *)codeKey
{
    objc_setAssociatedObject(self, responseCodeKeyKey, codeKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)responseSuccessCode
{
    return ESIntegerValue(objc_getAssociatedObject(self, responseSuccessCodeKey));
}

- (void)setResponseSuccessCode:(NSInteger)code
{
    objc_setAssociatedObject(self, responseSuccessCodeKey, @(code), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)responseMessageKey
{
    return objc_getAssociatedObject(self, responseMessageKeyKey);
}

- (void)setResponseMessageKey:(NSString *)messageKey
{
    objc_setAssociatedObject(self, responseMessageKeyKey, messageKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSDictionary *dict = [super responseObjectForResponse:response data:data error:error];

    // Check whether the response object is an NSDictionary object
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [self nc_serializationErrorWithCode:NSURLErrorCannotDecodeContentData
                                             description:NSLocalizedStringFromTable(@"Invalid response data #1", @"ESAPIClient", nil)
                                                response:response
                                            responseData:dict];
        }

        dict = nil;
    }

    // Check whether the response code is success or not
    if (dict && self.responseCodeKey) {
        if (!dict[self.responseCodeKey]) {
            // "code" key does not exist
            if (error) {
                *error = [self nc_serializationErrorWithCode:NSURLErrorCannotDecodeContentData
                                                 description:NSLocalizedStringFromTable(@"Invalid response data #2", @"ESAPIClient", nil)
                                                    response:response
                                                responseData:dict];
            }

            dict = nil;
        } else {
            NSInteger code = ESIntegerValue(dict[self.responseCodeKey]);
            if (code != self.responseSuccessCode) {
                // "code" value is not success
                if (error) {
                    *error = [self nc_serializationErrorWithCode:NSURLErrorCannotDecodeContentData
                                                     description:NSLocalizedStringFromTable(@"Invalid response data #3", @"ESAPIClient", nil)
                                                        response:response
                                                    responseData:dict];
                }

#if TARGET_OS_IOS
                // Parse and show the message
                if (self.responseMessageKey) {
                    [self nc_showHUDMessage:ESStringValue(dict[self.responseMessageKey]) delay:3];
                }
#endif

                dict = nil;
            }
        }
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

- (void)nc_showHUDMessage:(NSString *)message delay:(NSTimeInterval)delay
{
#if TARGET_OS_IOS
    if (!message.length) {
        return;
    }

    es_dispatch_async_main(^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        hud.label.text = message;
        [hud hideAnimated:YES afterDelay:delay];
    });
#endif
}

@end
