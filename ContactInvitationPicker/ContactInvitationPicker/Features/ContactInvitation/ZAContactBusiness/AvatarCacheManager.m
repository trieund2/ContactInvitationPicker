//
//  AvatarCacheManager.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/15/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "AvatarCacheManager.h"

@implementation AvatarCacheManager {
@private NIImageMemoryCache *imageMemoryCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        imageMemoryCache = [[NIImageMemoryCache alloc] init];
        long cacheSize = 20 * 1024 * 1024 * 8;
        int numberBitColor = 32;
        [imageMemoryCache setMaxNumberOfPixels:cacheSize/numberBitColor];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static AvatarCacheManager *avatarCacheManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        avatarCacheManager = [AvatarCacheManager new];
    });
    return avatarCacheManager;
}

- (void)storeImage:(UIImage *)image withKey:(NSString *)key {
    [imageMemoryCache storeObject:image withName:key];
}

- (UIImage *)getImageWithKey:(NSString *)key {
    return [imageMemoryCache objectWithName:key];
}

@end
