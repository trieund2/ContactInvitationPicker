//
//  ZAContactBusiness.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContactScaner.h"
#import "ZAContactBusinessModel.h"
#import "NSString+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactBusiness : NSObject

@property (nonatomic, readonly) NSMutableArray *contactBusinessModels;

- (void)getAllContactsFromLocalWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(void)) completionHandler
                               errorHandler:(void (^)(ZAContactError error)) errorHandler;

- (NSArray *)mapTitleAndContacts;

- (NSArray *)searchContactWithSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
