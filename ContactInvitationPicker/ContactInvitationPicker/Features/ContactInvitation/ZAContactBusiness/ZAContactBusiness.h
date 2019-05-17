//
//  ZAContactBusiness.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContactScanner.h"
#import "ZAContactBusinessModel.h"
#import "NSString+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactBusiness : NSObject

@property (weak, nonatomic) id<ZAContactScannerDelegate> delegate;

- (instancetype)initWithDelegate:(id<ZAContactScannerDelegate>)delegate;

- (void)getOrderContactsWithSortType:(ZAContactSortType)sortType
                   completionHandler:(void (^)(NSArray* contacts)) completionHandler
                        errorHandler:(void (^)(ZAContactError error)) errorHandler;


@end

NS_ASSUME_NONNULL_END
