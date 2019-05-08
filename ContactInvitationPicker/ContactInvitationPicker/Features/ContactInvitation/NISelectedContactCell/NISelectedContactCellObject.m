//
//  NISelectedContactCellObject.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NISelectedContactCellObject.h"
#import "NibSelectedContactCell.h"

@implementation NISelectedContactCellObject

- (id)initWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName {
    if (self = [super initWithCellClass:[NibSelectedContactCell class]]) {
        self.shortName = [shortName copy];
        self.phoneNumber = [phoneNumber copy];
        self.isSelected = NO;
    }
    return self;
}

+ (id)objectWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName {
    return [[self alloc] initWithPhoneNumber:phoneNumber shortName:shortName];
}

- (Class)cellClass {
    return [NibSelectedContactCell class];
}

@end
