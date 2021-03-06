//
//  ESAPIClient.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESAPIClient.h"

static ESAPIClient *_defaultClient = nil;

@implementation ESAPIClient

+ (instancetype)defaultClient
{
    if (!_defaultClient) {
        _defaultClient = [[self alloc] initWithBaseURL:nil sessionConfiguration:nil];
    }
    return _defaultClient;
}

+ (void)setDefaultClient:(ESAPIClient *)client
{
    if (_defaultClient != client) {
        NSString *key = NSStringFromSelector(@selector(defaultClient));
        [self willChangeValueForKey:key];
        _defaultClient = client;
        [self didChangeValueForKey:key];
    }
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer.timeoutInterval = 30;

        self.fileMultipartName = @"file";
        self.imageCompressionQuality = 0.7;
    }
    return self;
}

- (nullable NSURLSessionDataTask *)uploadFile:(NSURL *)fileURL
                                           to:(NSString *)URLString
                                   parameters:(nullable id)parameters
                                     progress:(nullable void (^)(NSProgress *progress))progress
                                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:fileURL name:self.fileMultipartName error:NULL];
    } progress:progress success:success failure:failure];
}

#if !TARGET_OS_OSX
- (void)uploadImage:(UIImage *)image
                 to:(NSString *)URLString
         parameters:(nullable id)parameters
           progress:(nullable void (^)(NSProgress *progress))progress
            success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
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
            [formData appendPartWithFileData:imageData name:self.fileMultipartName fileName:@"image.jpg" mimeType:@"image/jpeg"];
        } progress:progress success:success failure:failure];
    });
}
#endif

- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                         toFile:(NSURL *)fileURL
                                     parameters:(nullable id)parameters
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *destFileURL))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure
{
    return [self download:URLString parameters:parameters destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return fileURL;
    } progress:progress success:success failure:failure];
}

- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                    toDirectory:(NSURL *)directoryURL
                                     parameters:(nullable id)parameters
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *destFileURL))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure
{
    return [self download:URLString parameters:parameters destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [directoryURL URLByAppendingPathComponent:response.suggestedFilename isDirectory:NO];
    } progress:progress success:success failure:failure];
}

- (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString
                                     parameters:(nullable id)parameters
                                    destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       progress:(nullable void (^)(NSProgress *progress))progress
                                        success:(nullable void (^)(NSURLSessionDownloadTask *task, NSURL *destFileURL))success
                                        failure:(nullable void (^)(NSURLSessionDownloadTask * _Nullable task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }

        return nil;
    }

    __block NSURLSessionDownloadTask *task = [self downloadTaskWithRequest:request progress:progress destination:destination completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
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

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self GET:URLString parameters:parameters headers:nil progress:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self HEAD:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:uploadProgress success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self PUT:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:(nullable id)parameters
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self PATCH:URLString parameters:parameters headers:nil success:success failure:failure];
}

- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:(nullable id)parameters
                                  success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
{
    return [self DELETE:URLString parameters:parameters headers:nil success:success failure:failure];
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.fileMultipartName = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(fileMultipartName))];
        self.imageCompressionQuality = [decoder decodeDoubleForKey:NSStringFromSelector(@selector(imageCompressionQuality))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];

    [coder encodeObject:self.fileMultipartName forKey:NSStringFromSelector(@selector(fileMultipartName))];
    [coder encodeDouble:self.imageCompressionQuality forKey:NSStringFromSelector(@selector(imageCompressionQuality))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    ESAPIClient *client = [super copyWithZone:zone];

    client.fileMultipartName = [self.fileMultipartName copyWithZone:zone];
    client.imageCompressionQuality = self.imageCompressionQuality;

    return client;
}

@end
