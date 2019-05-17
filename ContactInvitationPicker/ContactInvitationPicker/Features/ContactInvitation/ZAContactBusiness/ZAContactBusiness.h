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

@property (nonatomic, readonly) ZAContactScanner *contactScanner;
@property (weak, nonatomic) id<ZAContactScannerDelegate> delegate;

- (instancetype)initWithDelegate:(id<ZAContactScannerDelegate>)delegate;

- (void)getContactsAndMapTitlesWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(NSArray* contacts)) completionHandler
                               errorHandler:(void (^)(ZAContactError error)) errorHandler;

- (void)clearAllContacts;

@end

NS_ASSUME_NONNULL_END
