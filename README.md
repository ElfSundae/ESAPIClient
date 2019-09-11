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
client.fileMultipartName = @"uploadFile";
ESAPIClient.defaultClient = client;
```

### Sending API requests

#### GET

```objc
[ESAPIClient.defaultClient GET:@"api/path" parameters:@{ @"foo": @"bar" } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    //
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
}];
```

#### Uploading file

```objc
[ESAPIClient.defaultClient uploadFile:fileURL
                                   to:@"upload/avatar"
                           parameters:@{ @"foo": @"bar" }
                             progress:^(NSProgress * _Nonnull progress) {
    dispatch_async(dispatch_get_main_queue(), ^{
        progressView.progress = progress.fractionCompleted;
    });
} success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
    //
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
}];
```

#### Downloading file

```objc
[ESAPIClient.defaultClient download:@"download/file.zip" toFile:destFile parameters:nil progress:nil success:^(NSURLSessionDownloadTask * _Nonnull task, NSURL * _Nonnull filePath) {
    //
} failure:^(NSURLSessionDownloadTask * _Nullable task, NSError * _Nonnull error) {
    //
}];

[ESAPIClient.defaultClient download:@"https://example.com/file.zip" toDirectory:destDir parameters:nil progress:nil success:^(NSURLSessionDownloadTask * _Nonnull task, NSURL * _Nonnull filePath) {
    //
} failure:^(NSURLSessionDownloadTask * _Nullable task, NSError * _Nonnull error) {
    //
}];
```

## License

ESAPIClient is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
