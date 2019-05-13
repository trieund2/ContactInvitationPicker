//
//  ZAContactBussiness.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContactScaner.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactBussiness : NSObject

- (void)requestAccessContactWithCompletionHandler:(void (^)(BOOL granted)) completionHandler
                                     errorHandler:(void (^)(NSError * _Nonnull error)) errorHandler;

- (NSArray *)sortContact;

- (void)getAllContactsFromLocal;

@end

NS_ASSUME_NONNULL_END
