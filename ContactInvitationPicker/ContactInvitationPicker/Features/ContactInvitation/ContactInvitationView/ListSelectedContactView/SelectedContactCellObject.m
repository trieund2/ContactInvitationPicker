//
//  SelectedContactCellObject.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "SelectedContactCellObject.h"
#import "SelectedContactCollectionViewCell.h"

@implementation SelectedContactCellObject

- (id)initWithContactCellObject:(ContactCellObject *)contactCellObject contactIndexPath:(NSIndexPath*)contactIndexPath {
    if (self = [super initWithCellClass:[SelectedContactCollectionViewCell class]]) {
        self.identifier = contactCellObject.identifier;
        self.fullNameRemoveDiacritics = contactCellObject.fullNameRemoveDiacritics;
        self.phoneNumber = contactCellObject.phoneNumber;
        self.contactIndexPath = contactIndexPath;
        self.color = contactCellObject.shortNameBackgroundColor;
    }
    return self;
}

+ (id)objectWithContactCellObject:(ContactCellObject *)contactCellObject contactIndexPath:(NSIndexPath*)contactIndexPath {
    return [[self alloc] initWithContactCellObject:contactCellObject contactIndexPath:contactIndexPath];
}

- (Class)cellClass {
    return [SelectedContactCollectionViewCell class];
}

- (BOOL)isEqual:(SelectedContactCellObject *)object {
    if ([self.fullNameRemoveDiacritics isEqual:object.fullNameRemoveDiacritics]
        && [self.phoneNumber isEqual:object.phoneNumber]
        && [self.contactIndexPath isEqual:object.contactIndexPath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
