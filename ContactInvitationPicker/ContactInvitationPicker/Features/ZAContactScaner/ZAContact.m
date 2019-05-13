//
//  ZAContact.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/11/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContact.h"

@implementation ZAContact

- (id)initFromContact:(CNContact *)contact {
    if (contact == NULL) { return NULL; }
    if (self = [super init]) {
        _phoneNumbers = [NSMutableArray new];
        for (CNPhoneNumber *phoneNumber in contact.phoneNumbers) {
            NSString *phone = [[phoneNumber valueForKey:@"value"] valueForKey:@"digits"];
            if (phone != NULL) {
                [self.phoneNumbers addObject:phone];
            }
        }
        if (self.phoneNumbers.count == 0) {
            return NULL;
        }
        _identifier = contact.identifier;
        _givenName = contact.givenName;
        _familyName = contact.familyName;
        _middleName = contact.middleName;
        _thumnailImageData = contact.imageData;
    }
    return self;
}

+ (id)objectFromContact:(CNContact *)contact {
    return [[self alloc] initFromContact:contact];
}

- (id)initFromABRecordRef:(ABRecordRef)recordRef {
    if (self = [super init]) {
        _phoneNumbers = [NSMutableArray new];
        // map phone numbers
        if (self.phoneNumbers.count == 0) {
            return NULL;
        }
        _givenName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonFirstNameProperty));
        _familyName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonLastNameProperty));
        _middleName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonMiddleNameProperty));
        _thumnailImageData = (__bridge NSData * _Nonnull)(ABPersonCopyImageData(recordRef));
    }
    return self;
}

+ (id)objectFromABRecordRef:(ABRecordRef)recordRef {
    return [[self alloc] initFromABRecordRef:recordRef];
}

@end
