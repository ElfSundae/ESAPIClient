//
//  ESJSONDictionaryResponseSerializer.m
//  ESAPIClient
//
//  Created by Elf Sundae on 2019/06/20.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "ESJSONDictionaryResponseSerializer.h"

@implementation ESJSONDictionaryResponseSerializer

- (BOOL)validateResponseObject:(nullable id)responseObject
{
    return ([responseObject isKindOfClass:[NSDictionary class]] &&
            (!self.responseCodeKey ||
             [(NSDictionary *)responseObject objectForKey:self.responseCodeKey]));
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
