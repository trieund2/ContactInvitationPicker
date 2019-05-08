//
//  NIContactCellObject.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCellObject.h"
#import "NINibContactCell.h"

@implementation NIContactCellObject

- (id)initWithTitle:(NSString *)title shortName:(NSString *)shortName {
    if (self = [super initWithCellClass:[NINibContactCell class]]) {
        _title = [title copy];
        _shortName = [shortName copy];
    }
    return self;
}

+ (id)objectWithTitle:(NSString *)title shortName:(NSString *)shortName {
    return [[self alloc] initWithTitle:title shortName:shortName];
}

- (Class)cellClass {
    return [NINibContactCell class];
}

@end
