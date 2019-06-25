//
//  ESAPIClient.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESAPIClient.h"

@implementation ESAPIClient
@dynamic responseSerializer;

static ESAPIClient *_defaultClient = nil;

+ (ESAPIClient *)defaultClient
{
    if (!_defaultClient) {
        _defaultClient = [self manager];
    }
    return _defaultClient;
}

+ (void)setDefaultClient:(ESAPIClient *)defaultClient
{
    _defaultClient = defaultClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.defaultMultipartNameForFile = @"file";
        self.imageCompressionQuality = 1.0;

        self.requestSerializer.timeoutInterval = 40;

        self.responseSerializer = [ESJSONDictionaryResponseSerializer serializer];
    }
    return self;
}

#if !TARGET_OS_OSX
- (void)uploadImage:(UIImage *)image
                 to:(NSString *)URLString
         parameters:(nullable NSDictionary *)parameters
           progress:(nullable void (^)(NSProgress *progress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = UIImageJPEGRepresentation(image, self.imageCompressionQuality);

        if (!imageData) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:AFURLRequestSerializationErrorDomain
                                                     code:NSURLErrorCannotDecodeContentData
                                                 userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Could not generate image data", @"ESAPIClient", nil) }];
                dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                    failure(nil, error);
                });
            }

            return;
        }

        [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:self.defaultMultipartNameForFile fileName:@"image.jpg" mimeType:@"image/jpeg"];
        } progress:progress success:success failure:failure];
    });
}
#endif

- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                    toDirectory:(NSURL *)directoryURL
                                       filename:(nullable NSString *)filename
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *filePath))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self fullURL:URLString]];

    __block NSURLSessionDownloadTask *task = nil;
    task = [self downloadTaskWithRequest:request progress:progress destination:^NSURL * _Nonnull (NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [directoryURL URLByAppendingPathComponent:filename ?: response.suggestedFilename isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, filePath);
            }
        }
    }];

    [task resume];

    return task;
}

#pragma mark - Subclass

// Since we changed the method signature, i.e. changed `id` to `NSDictionary` for
// `parameters` and `responseObject`, Xcode will warning "Method definition not found",
// so just implement these methods in our .m file.

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                              progress:(nullable void (^)(NSProgress *progress))progress
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
{
    return [super GET:URLString parameters:parameters progress:progress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
{
    return [super POST:URLString parameters:parameters progress:progress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *progress))progress
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
{
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block progress:progress success:success failure:failure];
}

// These three methods below have been marked as deprecated in the AFNetworking,
// we put them in our .h file to eliminate build warnings.

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, NSDictionary * _Nullable response))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    ESAPIClient *client = [super copyWithZone:zone];

    client.defaultMultipartNameForFile = [self.defaultMultipartNameForFile copyWithZone:zone];
    client.imageCompressionQuality = self.imageCompressionQuality;

    return client;
}

@end
