# ESAPIClient

[![Build Status](https://travis-ci.org/ElfSundae/ESAPIClient.svg)](https://travis-ci.org/ElfSundae/ESAPIClient)

ESAPIClient is an API client library built on top of [AFNetworking](https://github.com/AFNetworking/AFNetworking).

## Requirements

- Minimum deployment target: iOS 9.0, macOS 10.11, watchOS 2.0, tvOS 9.0

## Installation

```ruby
pod 'ESAPIClient'
```

## Usage

### Setup the default API client for your application

```objc
NSURL *baseURL = [NSURL URLWithString:@"https://api.github.com"];
ESAPIClient *client = [[ESAPIClient alloc] initWithBaseURL:baseURL];

[client.requestSerializer setValue:<#customUserAgent#> forHTTPHeaderField:@"User-Agent"];
client.requestSerializer.HTTPRequestHeadersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSURLRequest * _Nonnull request, id _Nullable parameters) {
    return @{@"ApiVersion": @"3"};
};
client.requestSerializer.URLQueryParametersBlock = ^NSDictionary<NSString *, id> * _Nullable (NSString * _Nonnull method, NSString * _Nonnull URLString, id _Nullable parameters) {
    return @{@"_time": @((long)[NSDate date].timeIntervalSince1970)};
};

#if defined(DEBUG) && DEBUG
client.logger.enabled = YES;
[client.logger setLogLevel:AFLoggerLevelDebug];
#endif

ESAPIClient.defaultClient = client;
```

Optionally you may define a macro for the default client in the prefix header file:

```objc
#import <ESAPIClient/ESAPIClient.h>

#ifndef API
#define API [ESAPIClient defaultClient]
#endif
```

### Sending API requests

#### GET

```objc
[ESAPIClient.defaultClient GET:@"api/path" parameters:@{ @"foo": @"bar" } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
    //
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
}];
```

#### Uploading file

```objc
[ESAPIClient.defaultClient POST:@"upload/avatar" parameters:@{@"foo": @"bar"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileURL:fileURL name:APIClient.defaultMultipartNameForFile error:NULL];
} success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable response) {
    //
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
}];
```

#### Downloading file with progress

```objc
[ESAPIClient.defaultClient
    download:@"http://path/to/file"
    toDirectory:[NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject
    filename:NSUUID.UUID.UUIDString
    progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progress.fractionCompleted;
        });
    } success:^(NSURLSessionDownloadTask * _Nonnull task, NSURL * _Nonnull filePath) {
        //
    } failure:^(NSURLSessionDownloadTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
```

## License

ESAPIClient is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
