//
//  ZAContactBusinessModel.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusinessModel.h"

@implementation ZAContactBusinessModel

- (id)initWithZaContact:(ZAContact *)zaContact {
    if (self = [super init]) {
        _givenName = zaContact.givenName;
        _middleName = zaContact.middleName;
        _familyName = zaContact.familyName;
        _phoneNumbers = zaContact.phoneNumbers;
        _fullName = [NSString stringWithFormat:@"%@ %@ %@", self.familyName, self.middleName, self.givenName];
        _fullName = [self.fullName stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        _fullNameRemoveDiacritics = [NSString stringRemoveDiacriticsFromString:self.fullName];
    }
    return self;
}

+ (id)objectWithZaContact:(ZAContact *)zaContact {
    return [[self alloc] initWithZaContact:zaContact];
}

@end
