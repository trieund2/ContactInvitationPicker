//
//  Contact.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (id)contactWithFirstName:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumber {
    Contact *contact = [Contact new];
    contact.firstName = firstName;
    contact.lastName = lastName;
    contact.phoneNumber = phoneNumber;
    if ([lastName length] == 0) {
        contact.fullName = firstName;
    } else {
        contact.fullName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
    }
    
    NSMutableArray *words = [NSMutableArray new];
    
    [contact.fullName enumerateSubstringsInRange:NSMakeRange(0, [contact.fullName length])
                                         options:NSStringEnumerationByWords
                                      usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                                          [words addObject:substring];
    }];
    
    if (words.count > 1) {
        NSString *first = [[words firstObject] substringToIndex:1];
        NSString *last = [[words lastObject] substringToIndex:1];
        contact.shortName = [NSString stringWithFormat:@"%@%@", first, last];
    } else {
        contact.shortName = [[words firstObject] substringToIndex:1];;
    }
    
    return contact;
}

@end
