//
//  ContactCellObject.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactCellObject.h"
#import "ContactTableViewCell.h"
#import "UIColorFromRGB.h"
#import "NSString+Extension.h"

@implementation ContactCellObject

- (id)initFromContact:(ZAContactAdapterModel *)contact {
    if (self = [super initWithCellClass:[ContactTableViewCell class]]) {
        _identifier = contact.identifier;
        _fullName = contact.fullName;
        _fullNameRemoveDiacritics = contact.fullNameRemoveDiacritics;
        _phoneNumber = contact.phoneNumbers.firstObject;
        
        NSArray *colors = [NSArray arrayWithObjects:
                           UIColorFromRGB(0xB6B8EA),
                           UIColorFromRGB(0x97D3C4),
                           UIColorFromRGB(0xCBAEA0),
                           UIColorFromRGB(0xB4B9C8),
                           UIColorFromRGB(0xF1A5A5),
                           UIColorFromRGB(0xA2C8DA),
                           UIColorFromRGB(0x85CBDD),
                           nil];
        int index = (int)([_fullNameRemoveDiacritics length] % colors.count);
        _shortNameBackgroundColor = [colors objectAtIndex:index];
    }
    
    return self;
}

+ (id)objectFromContact:(ZAContactAdapterModel *)contact {
    return [[self alloc] initFromContact:contact];
}

- (Class)cellClass {
    return [ContactTableViewCell class];
}

@end
