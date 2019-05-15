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

- (id)initFromContact:(ZAContactBusinessModel *)contact {
    if (self = [super initWithCellClass:[NIContactTableViewCell class]]) {
        self.fullName = contact.fullName;
        self.fullNameRemoveDiacritics = contact.fullNameRemoveDiacritics;
        self.phoneNumber = contact.phoneNumbers.firstObject;
        
        NSArray *colors = [NSArray arrayWithObjects:
                           UIColorFromRGB(0xB6B8EA),
                           UIColorFromRGB(0x97D3C4),
                           UIColorFromRGB(0xCBAEA0),
                           UIColorFromRGB(0xB4B9C8),
                           UIColorFromRGB(0xF1A5A5),
                           UIColorFromRGB(0xA2C8DA),
                           UIColorFromRGB(0x85CBDD), nil];
        int index = (int)([self.fullNameRemoveDiacritics length] % colors.count);
        self.shortNameBackgroundColor = [colors objectAtIndex:index];
    }
    return self;
}

+ (id)objectFromContact:(ZAContactBusinessModel *)contact {
    return [[self alloc] initFromContact:contact];
}

- (Class)cellClass {
    return [NIContactTableViewCell class];
}

- (BOOL)isEqual:(NIContactCellObject *)contactCellObject
{
    if ([self.fullName isEqual:contactCellObject.fullName]
        && [self.fullNameRemoveDiacritics isEqual:contactCellObject.fullNameRemoveDiacritics]
        && [self.shortNameBackgroundColor isEqual:contactCellObject.shortNameBackgroundColor]
        && [self.phoneNumber isEqual:contactCellObject.phoneNumber]
        && self.isSelected == contactCellObject.isSelected) {
        return YES;
    } else {
        return NO;
    }
}

@end
