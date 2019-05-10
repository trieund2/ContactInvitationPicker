//
//  NIContactCellObject.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCellObject.h"
#import "NIContactTableViewCell.h"
#import "UIColorFromRGB.h"
#import "NSString+Extension.h"

@implementation NIContactCellObject

- (id)initFromContact:(CNContact *)contact {
    if (self = [super initWithCellClass:[NIContactTableViewCell class]]) {
        NSString *phoneNumber = [[contact.phoneNumbers.firstObject valueForKey:@"value"] valueForKey:@"digits"];
        if (phoneNumber != nil && [phoneNumber length] != 0) {
            self.phoneNumber = phoneNumber;
            self.fullName = [CNContactFormatter stringFromContact:contact style:(CNContactFormatterStyleFullName)];
            self.fullNameIgnoreUnicode = [NSString stringIgnoreUnicodeFromString:self.fullName];
            
            NSMutableArray *words = [NSMutableArray new];
            [self.fullNameIgnoreUnicode enumerateSubstringsInRange:NSMakeRange(0, [self.fullNameIgnoreUnicode length])
                                           options:NSStringEnumerationByWords
                                        usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                                            [words addObject:substring];
                                        }];
            
            if (words.count > 1) {
                NSString *first = [[[words firstObject] substringToIndex:1] uppercaseString];
                NSString *last = [[[words lastObject] substringToIndex:1] uppercaseString];
                self.shortName = [NSString stringWithFormat:@"%@%@", first, last];
            } else {
                self.shortName = [[[words firstObject] substringToIndex:1] uppercaseString];
            }
            
            NSArray *colors = [NSArray arrayWithObjects:
                               UIColorFromRGB(0xB6B8EA),
                               UIColorFromRGB(0x97D3C4),
                               UIColorFromRGB(0xCBAEA0),
                               UIColorFromRGB(0xB4B9C8),
                               UIColorFromRGB(0xF1A5A5),
                               UIColorFromRGB(0xA2C8DA),
                               UIColorFromRGB(0x85CBDD), nil];
            int index = (int)([self.fullNameIgnoreUnicode length] % colors.count);
            self.shortNameBackgroundColor = [colors objectAtIndex:index];
        } else {
            return nil;
        }
    }
    return self;
}

+ (id)objectFromContact:(CNContact *)contact {
    return [[self alloc] initFromContact:contact];
}

- (Class)cellClass {
    return [NIContactTableViewCell class];
}

@end
