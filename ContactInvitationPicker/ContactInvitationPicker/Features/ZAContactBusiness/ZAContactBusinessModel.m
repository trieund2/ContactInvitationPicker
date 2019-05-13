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
        _fullName = [_fullName stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        _fullNameIgnoreUnicode = [NSString stringIgnoreUnicodeFromString:self.fullName];
        
        NSMutableArray *words = [NSMutableArray new];
        [self.fullNameIgnoreUnicode enumerateSubstringsInRange:NSMakeRange(0, [self.fullNameIgnoreUnicode length])
                                                       options:NSStringEnumerationByWords
                                                    usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                                                        [words addObject:substring];
                                                    }];
        if (words.count > 1) {
            NSString *firstWord = [words firstObject];
            NSString *lastWord = [words lastObject];
            if ([firstWord length] > 0 && [lastWord length] > 0) {
                _shortName = [NSString stringWithFormat:@"%@%@", [firstWord substringToIndex:1].uppercaseString, [lastWord substringToIndex:1].uppercaseString];
            } else if ([firstWord length] > 0) {
                _shortName = [NSString stringWithFormat:@"%@", [firstWord substringToIndex:1].uppercaseString];
            } else if ([lastWord length] > 0) {
                _shortName = [NSString stringWithFormat:@"%@", [lastWord substringToIndex:1].uppercaseString];
            }
        } else if (words.count == 1 && [[words firstObject] length] > 0) {
            _shortName = [[[words firstObject] substringToIndex:1] uppercaseString];
        }
    }
    return self;
}

+ (id)objectWithZaContact:(ZAContact *)zaContact {
    return [[self alloc] initWithZaContact:zaContact];
}

@end
