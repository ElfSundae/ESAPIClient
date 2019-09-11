//
//  ESAPIClient.h
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <AFNetworkingExtension/AFNetworkingExtension.h>
#import "ESJSONDictionaryResponseSerializer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESAPIClient : AFHTTPSessionManager

/**
 * The default API client instance.
 * @discussion The -defaultClient is KVO-compatible.
 */
+ (instancetype)defaultClient;

/**
 * Set the default API client instance.
 * @discussion The -defaultClient is KVO-compatible.
 */
+ (void)setDefaultClient:(ESAPIClient *)client;

/**
 * The multipart `name` for uploading file.
 * @discussion The default value is "file".
 */
@property (nonatomic, copy) NSString *fileMultipartName;

/**
 * The compression quality for the uploading image, expressed as a value from
 * 0.0 to 1.0, the default quality is 0.9.
 * @discussion The value 0.0 represents the maximum compression (or lowest
 * quality) while the value 1.0 represents the least compression (or best quality).
 */
@property (nonatomic) CGFloat imageCompressionQuality;

/**
 * Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 */
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 * Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 */
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                              progress:(nullable void (^)(NSProgress *progress))progress
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 * Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 * Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 * Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

/**
 * Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

#if !TARGET_OS_OSX
/**
 * Upload an UIImage as JPEG with a multipart `POST` request.
 * @discussion Image will be compressed to data in JPEG format before uploading.
 */
- (void)uploadImage:(UIImage *)image
                 to:(NSString *)URLString
         parameters:(nullable NSDictionary *)parameters
           progress:(nullable void (^)(NSProgress *progress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
#endif

/**
 * Creates and runs an `NSURLSessionDownloadTask` with the specified URL.
 */
- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                    toDirectory:(NSURL *)directoryURL
                                       filename:(nullable NSString *)filename
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *filePath))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
