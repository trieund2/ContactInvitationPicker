//
//  ZAContactAdapter.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContactScanner.h"
#import "ZAContactAdapterModel.h"
#import "NSString+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactAdapter : NSObject

+ (instancetype)sharedInstance;

- (void)delegateTo:(id<ZAContactScannerDelegate>)forwardDelegate;
- (void)removeDelegate:(id<ZAContactScannerDelegate>)forwardDelegate;

- (void)getOrderContactsWithSortType:(ZAContactSortType)sortType
                   completionHandler:(void (^)(NSArray* contacts)) completionHandler
                        errorHandler:(void (^)(ZAContactError error)) errorHandler;


@end

NS_ASSUME_NONNULL_END
