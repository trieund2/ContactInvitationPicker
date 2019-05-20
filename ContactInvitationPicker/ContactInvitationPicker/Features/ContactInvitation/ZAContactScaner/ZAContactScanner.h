//
//  ZAContactScaner.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "ZAContact.h"
#import "NSString+Extension.h"
#import "NimbusCore.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZAContactSortType) {
    ZAContactSortTypeNone,
    ZAContactSortTypeFamilyName,
    ZAContactSortTypeGivenName
};

typedef NS_ENUM(NSInteger, ZAContactError) {
    ZAContactErrorNotPermittedByStore = 0,
    ZAContactErrorNotPermitterByUser  = 1
};

@class ZAContactScanner;

@protocol ZAContactScannerDelegate <NSObject>

@required
- (void)contactDidChange;

@end

@interface ZAContactScanner : NSObject

+ (instancetype)sharedInstance;

- (void)requestAccessContactWithAccessGranted:(void (^)(void)) accessGranted
                                 accessDenied:(void (^)(void)) accessDenied;

- (void)getContactsWithSortType:(ZAContactSortType)sortType
              completionHandler:(void (^)(ZAContact * contact))completionHandler
                   errorHandler:(void (^)(ZAContactError error)) errorHandler;

- (void)delegateTo:(id<ZAContactScannerDelegate>)forwardDelegate;
- (void)removeDelegate:(id<ZAContactScannerDelegate>)forwardDelegate;

@end

NS_ASSUME_NONNULL_END
