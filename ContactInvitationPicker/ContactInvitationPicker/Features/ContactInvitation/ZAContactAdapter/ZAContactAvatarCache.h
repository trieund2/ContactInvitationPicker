//
//  ZAContactAvatarCache.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/15/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NIInMemoryCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactAvatarCache : NSObject

+ (instancetype)sharedInstance;
- (void)storeImage:(UIImage*)image withKey:(NSString*)key;
- (UIImage*)getImageWithKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
