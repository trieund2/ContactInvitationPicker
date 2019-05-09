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

- (id)initWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName indexPath:(NSIndexPath *)indexPath {
    if (self = [super initWithCellClass:[NibSelectedContactCell class]]) {
        self.shortName = [shortName copy];
        self.phoneNumber = [phoneNumber copy];
        self.indexPath = indexPath;
    }
    return self;
}

+ (id)objectWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName indexPath:(NSIndexPath *)indexPath {
    return [[self alloc] initWithPhoneNumber:phoneNumber shortName:shortName indexPath:indexPath];
}

- (Class)cellClass {
    return [NibSelectedContactCell class];
}

- (BOOL)isEqual:(NISelectedContactCellObject *)object {
    if ([self.shortName isEqual:object.shortName]
        && [self.phoneNumber isEqual:object.phoneNumber]
        && [self.indexPath isEqual:object.indexPath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
