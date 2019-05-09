//
//  NIContactCellObject.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCellObject.h"
#import "NIContactCell.h"
#import "UIColorFromRGB.h"

@implementation NIContactCellObject

- (id)initFromContact:(CNContact *)contact {
    if (self = [super initWithCellClass:[NIContactCell class]]) {
        NSString *firstName = contact.givenName;
        NSString *lastName = contact.familyName;
        NSString *phone = [[contact.phoneNumbers.firstObject valueForKey:@"value"] valueForKey:@"digits"];
        
        if (phone != nil && [phone length] != 0 && ([firstName length] != 0 || [lastName length] != 0)) {
            self.phoneNumber = [phone copy];
            if ([lastName length] == 0) {
                self.displayName = firstName;
            } else {
                self.displayName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
            }
            
            NSMutableArray *words = [NSMutableArray new];
            
            [self.displayName enumerateSubstringsInRange:NSMakeRange(0, [self.displayName length])
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
            
            NSArray *colors = [NSArray arrayWithObjects:UIColorFromRGB(0xB6B8EA), UIColorFromRGB(0x97D3C4), UIColorFromRGB(0xCBAEA0), UIColorFromRGB(0xB4B9C8), UIColorFromRGB(0xF1A5A5), UIColorFromRGB(0xA2C8DA), UIColorFromRGB(0x85CBDD), nil];
            int index = (int)([self.displayName length] % colors.count);
            self.color = [colors objectAtIndex:index];
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
    return [NIContactCell class];
}

@end
