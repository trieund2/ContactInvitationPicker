//
//  NIContactCellObject.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCellObject.h"
#import "NIContactCell.h"

@implementation NIContactCellObject

- (id)initWithTitle:(NSString *)title shortName:(NSString *)shortName {
    if (self = [super initWithCellClass:[NIContactCell class]]) {
        self.title = [title copy];
        self.shortName = [shortName copy];
        self.isSelected = NO;
    }
    return self;
}

+ (id)objectWithTitle:(NSString *)title shortName:(NSString *)shortName {
    return [[self alloc] initWithTitle:title shortName:shortName];
}

- (Class)cellClass {
    return [NIContactCell class];
}

@end
