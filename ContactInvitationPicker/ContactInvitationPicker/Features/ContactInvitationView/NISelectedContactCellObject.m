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

- (id)initWithPhoneNumber:(NSString *)phoneNumber
                fullName:(NSString *)fullName
                indexPath:(NSIndexPath *)indexPath
                    color:(UIColor *)color {
    if (self = [super initWithCellClass:[NISelectedContactCollectionViewCell class]]) {
        self.fullName = [fullName copy];
        self.phoneNumber = [phoneNumber copy];
        self.indexPath = indexPath;
        self.color = color;
    }
    return self;
}

+ (id)objectWithPhoneNumber:(NSString *)phoneNumber
                  fullName:(NSString *)fullName
                  indexPath:(NSIndexPath *)indexPath
                      color:(UIColor *)color {
    return [[self alloc] initWithPhoneNumber:phoneNumber fullName:fullName indexPath:indexPath color:color];
}

- (Class)cellClass {
    return [NISelectedContactCollectionViewCell class];
}

- (BOOL)isEqual:(NISelectedContactCellObject *)object {
    if ([self.fullName isEqual:object.fullName]
        && [self.phoneNumber isEqual:object.phoneNumber]
        && [self.indexPath isEqual:object.indexPath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
