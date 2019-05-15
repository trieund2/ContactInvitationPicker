//
//  NISelectedContactCellObject.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NISelectedContactCellObject.h"
#import "NISelectedContactCollectionViewCell.h"

@implementation NISelectedContactCellObject

- (id)initWithContactCellObject:(NIContactCellObject *)contactCellObject indexPath:(NSIndexPath*)indexPath {
    if (self = [super initWithCellClass:[NISelectedContactCollectionViewCell class]]) {
        self.fullNameRemoveDiacritics = contactCellObject.fullNameRemoveDiacritics;
        self.phoneNumber = contactCellObject.phoneNumber;
        self.contactIndexPath = indexPath;
        self.color = contactCellObject.shortNameBackgroundColor;
    }
    return self;
}

+ (id)objectWithContactCellObject:(NIContactCellObject *)contactCellObject indexPath:(NSIndexPath*)indexPath {
    return [[self alloc] initWithContactCellObject:contactCellObject indexPath:indexPath];
}

- (Class)cellClass {
    return [NISelectedContactCollectionViewCell class];
}

- (BOOL)isEqual:(NISelectedContactCellObject *)object {
    if ([self.fullNameRemoveDiacritics isEqual:object.fullNameRemoveDiacritics]
        && [self.phoneNumber isEqual:object.phoneNumber]
        && [self.contactIndexPath isEqual:object.contactIndexPath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
