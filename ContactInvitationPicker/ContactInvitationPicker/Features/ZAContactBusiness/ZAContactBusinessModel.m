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
        _fullNameIgnoreUnicode = [NSString stringIgnoreUnicodeFromString:_fullName];
        _imageData = zaContact.thumnailImageData;
        
        NSMutableArray *words = [NSMutableArray new];
        [self.fullNameIgnoreUnicode enumerateSubstringsInRange:NSMakeRange(0, [self.fullNameIgnoreUnicode length])
                                                       options:NSStringEnumerationByWords
                                                    usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                                                        [words addObject:substring];
                                                    }];
        if (words.count > 1) {
            NSString *firstWord = [[[words firstObject] substringToIndex:1] uppercaseString];
            NSString *lastWord = [[[words lastObject] substringToIndex:1] uppercaseString];
            _shortName = [NSString stringWithFormat:@"%@%@", firstWord, lastWord];
        } else {
            _shortName = [[[words firstObject] substringToIndex:1] uppercaseString];
        }
    }
    return self;
}

+ (id)objectWithZaContact:(ZAContact *)zaContact {
    return [[self alloc] initWithZaContact:zaContact];
}

@end
