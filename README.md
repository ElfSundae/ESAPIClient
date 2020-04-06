# ESAPIClient

[![Build status](https://github.com/ElfSundae/ESAPIClient/workflows/Build/badge.svg)](https://github.com/ElfSundae/ESAPIClient/actions?query=workflow%3ABuild)
![CocoaPods](https://img.shields.io/cocoapods/v/ESAPIClient)
![CocoaPods platforms](https://img.shields.io/cocoapods/p/ESAPIClient)

ESAPIClient is an API client library built on top of [AFNetworking](https://github.com/AFNetworking/AFNetworking).

## Requirements

- Minimum deployment target: iOS 9.0, macOS 10.10, watchOS 2.0, tvOS 9.0

## Installation

```ruby
pod 'ESAPIClient'
```

If you are using AFNetworking 3.x, you need to add my spec-repo source URL before the Trunk source in your `Podfile`:

```ruby
source 'https://github.com/ElfSundae/CocoaPods-Specs.git'
source 'https://cdn.cocoapods.org/'

target 'Example' do
    pod 'ESAPIClient'
end
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
