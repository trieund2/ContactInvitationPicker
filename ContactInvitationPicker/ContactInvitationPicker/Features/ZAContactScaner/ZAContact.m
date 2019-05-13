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
        _identifier = contact.identifier;
        _givenName = contact.givenName;
        _familyName = contact.familyName;
        _middleName = contact.middleName;
        _thumNailImageData = contact.thumbnailImageData;
        _phoneNumbers = [NSMutableArray new];
        
        for (CNPhoneNumber *phoneNumber in contact.phoneNumbers) {
            NSString *phone = [[phoneNumber valueForKey:@"value"] valueForKey:@"digits"];
            [self.phoneNumbers addObject:phone];
        }
        
    }
    return self;
}

+ (id)objectFromContact:(CNContact *)contact {
    return [[self alloc] initFromContact:contact];
}

- (id)initFromABRecordRef:(ABRecordRef)recordRef {
    if (self = [super init]) {
        _givenName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonFirstNameProperty));
        _familyName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonLastNameProperty));
        _middleName = (__bridge NSString * _Nonnull)(ABRecordCopyValue(recordRef, kABPersonMiddleNameProperty));
    }
    return self;
}

+ (id)objectFromABRecordRef:(ABRecordRef)recordRef {
    return [[self alloc] initFromABRecordRef:recordRef];
}

@end
