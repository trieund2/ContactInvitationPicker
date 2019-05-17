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

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) ZAContactScanner *contactScanner;
@property (nonatomic, readonly) NSMutableArray *contactBusinessModels;
@property (weak, nonatomic) id<ZAContactScannerDelegate> delegate;

- (void)getAllContactsFromLocalWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(void)) completionHandler
                               errorHandler:(void (^)(ZAContactError error)) errorHandler;

- (NSArray *)mapTitleAndContacts;
- (void)clearAllContacts;

@end

NS_ASSUME_NONNULL_END
