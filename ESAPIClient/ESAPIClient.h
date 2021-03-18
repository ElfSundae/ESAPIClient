//
//  ESAPIClient.h
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <ESAPIClient/ESJSONDictionaryResponseSerializer.h>

#import <AFNetworking/AFHTTPSessionManager.h>

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
 * 0.0 to 1.0, the default quality is 0.7.
 * @discussion The value 0.0 represents the maximum compression (or lowest
 * quality) while the value 1.0 represents the least compression (or best quality).
 */
@property (nonatomic) CGFloat imageCompressionQuality;

/**
 * Uploads a file with a multipart `POST` request.
 * @discussion self.fileMultipartName will be used as the multipart name for the
 * uploading file, the content type of uploading file will be automatically
 * detected from the file extension.
 */
- (nullable NSURLSessionDataTask *)uploadFile:(NSURL *)fileURL
                                           to:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                     progress:(nullable void (^)(NSProgress *progress))progress
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

#if !TARGET_OS_OSX
/**
 * Upload an UIImage as JPEG data with a multipart `POST` request.
 * @discussion The image will be compressed to JPEG data with
 * self.imageCompressionQuality before uploading.
 */
- (void)uploadImage:(UIImage *)image
                 to:(NSString *)URLString
         parameters:(nullable id)parameters
           progress:(nullable void (^)(NSProgress *progress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
#endif

/**
 * Downloads a file with a "GET" request.
 */
- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                         toFile:(NSURL *)fileURL
                                     parameters:(nullable id)parameters
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *destFileURL))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure;

/**
 * Downloads a file with a "GET" request.
 */
- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                    toDirectory:(NSURL *)directoryURL
                                     parameters:(nullable id)parameters
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *destFileURL))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure;

// These methods below have been marked as deprecated in AFNetworking,
// we override them here and remove DEPRECATED_ATTRIBUTE to silence the
// deprecated-warning.

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
