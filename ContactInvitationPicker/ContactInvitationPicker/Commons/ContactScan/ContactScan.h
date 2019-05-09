//
//  ContactScan.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactScan : NSObject

+ (void)scanContact:(void (^)(NSArray * _Nonnull contacts))completion notGranted:(void (^)(void))notGranted;

@end

NS_ASSUME_NONNULL_END
