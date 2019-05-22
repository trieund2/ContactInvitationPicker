//
//  CNContactStoreMock.m
//  ContactInvitationPickerTests
//
//  Created by CPU12202 on 5/22/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "CNContactStoreMock.h"

typedef void(^FetchContactCompletionBlock)(CNContact * _Nonnull, BOOL * _Nonnull);

@implementation CNContactStoreMock

- (void)requestAccessForEntityType:(CNEntityType)entityType
                 completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    completionHandler(YES, NULL);
}

- (BOOL)enumerateContactsWithFetchRequest:(CNContactFetchRequest *)fetchRequest
                                    error:(NSError *__autoreleasing  _Nullable *)error
                               usingBlock:(void (^)(CNContact * _Nonnull, BOOL * _Nonnull))block {
    
    block([[CNContact alloc] init], YES);
    return YES;
}

@end
