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

@protocol ZAContactScannerDelegate <NSObject>

@required
- (void)contactDidChange;

@end

@interface ZAContactScanner : NSObject

@property (weak, nonatomic) id<ZAContactScannerDelegate> delegate;

- (void)requestAccessContactWithAccessGranted:(void (^)(void)) accessGranted
                                 accessDenied:(void (^)(void)) accessDenied;

- (void)getContactsWithSortType:(ZAContactSortType)sortType
              completionHandler:(void (^)(NSArray<ZAContact *>* contacts))completionHandler
                   errorHandler:(void (^)(ZAContactError error)) errorHandler;

@end

NS_ASSUME_NONNULL_END
