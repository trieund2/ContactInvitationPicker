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

- (void)requestAccessContactWithCompletionHandler:(void (^)(BOOL granted)) completionHandler
                                     errorHandler:(void (^)(NSError *error)) errorHandler;

- (void)getAllContactsFromLocalWithCompletionHalder:(void (^)(void)) completionHalder
                                                  errorHandler:(void (^)(NSError *error)) errorHandler;

- (NSArray *)mapContactAndTitles;

- (NSArray *)searchContactWithSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END
