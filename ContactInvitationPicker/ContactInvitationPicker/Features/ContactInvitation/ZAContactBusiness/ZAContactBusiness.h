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
@property (nonatomic, readonly) NSMutableArray *contactBusinessModels;
@property (nonatomic) void (^onContactChange)(void);

- (void)getAllContactsFromLocalWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(void)) completionHandler
                               errorHandler:(void (^)(ZAContactError error)) errorHandler;

- (NSArray *)mapTitleAndContacts;

@end

NS_ASSUME_NONNULL_END
