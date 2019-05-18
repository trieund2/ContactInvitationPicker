//
//  ZAContactAvatarCache.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/15/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactAvatarCache.h"

@implementation ZAContactAvatarCache {
    
@private NIImageMemoryCache *imageMemoryCache;
    
}

+ (instancetype)sharedInstance {
    static ZAContactAvatarCache *avatarCacheManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        avatarCacheManager = [ZAContactAvatarCache new];
    });
    return avatarCacheManager;
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

- (void)storeImage:(UIImage *)image withKey:(NSString *)key {
    if (![imageMemoryCache containsObjectWithName:key]) {
        [imageMemoryCache storeObject:image withName:key];
    }
}

- (UIImage *)getImageWithKey:(NSString *)key {
    return [imageMemoryCache objectWithName:key];
}

@end
