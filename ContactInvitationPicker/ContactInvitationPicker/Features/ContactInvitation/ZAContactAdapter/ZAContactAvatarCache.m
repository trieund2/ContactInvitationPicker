//
//  ZAContactAvatarCache.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/15/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactAvatarCache.h"

@interface ZAContactAvatarCache ()

@property (nonatomic) NIImageMemoryCache *imageMemoryCache;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation ZAContactAvatarCache

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
        _imageMemoryCache = [[NIImageMemoryCache alloc] init];
        long cacheSize = 20 * 1024 * 1024 * 8;
        int numberBitColor = 32;
        [self.imageMemoryCache setMaxNumberOfPixels:cacheSize/numberBitColor];
        _queue = dispatch_queue_create("ZAContactAvatarCache", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)storeImage:(UIImage *)image withKey:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(self.queue, ^{
        if (![weakSelf.imageMemoryCache containsObjectWithName:key]) {
            [weakSelf.imageMemoryCache storeObject:image withName:key];
        }
    });
}

- (UIImage *)getImageWithKey:(NSString *)key {
    __weak typeof(self) weakSelf = self;
    __block UIImage *cacheResult;
    dispatch_sync(self.queue, ^{
        cacheResult = [weakSelf.imageMemoryCache objectWithName:key];
    });
    return cacheResult;
}

@end
