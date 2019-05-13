//
//  ZAContact.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/11/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAContact : NSObject

@property (nonatomic, readonly, copy) NSString *identifier;
@property (nonatomic, readonly, copy) NSString *givenName;
@property (nonatomic, readonly, copy) NSString *middleName;
@property (nonatomic, readonly, copy) NSString *familyName;
@property (nonatomic, readonly) NSData *thumNailImageData;
@property (nonatomic, readonly) NSMutableArray<NSString *> *phoneNumbers;

- (id)initFromContact:(CNContact * _Nullable)contact API_AVAILABLE(ios(9.0));
+ (id)objectFromContact:(CNContact * _Nullable)contact API_AVAILABLE(ios(9.0));
- (id)initFromABRecordRef:(ABRecordRef) recordRef;
+ (id)objectFromABRecordRef:(ABRecordRef) recordRef;

@end

NS_ASSUME_NONNULL_END
