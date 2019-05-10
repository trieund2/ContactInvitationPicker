//
//  NISelectedContactCollectionViewCell.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NISelectedContactCollectionViewCell.h"
#import "NISelectedContactCellObject.h"

@implementation NISelectedContactCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initShortNameLabel];
        [self layoutShortNameLabel];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(NISelectedContactCellObject *)object {
    self.shortNameLabel.text = object.shortName;
    self.shortNameLabel.backgroundColor = object.color;
    return YES;
}

- (void)initShortNameLabel {
    _shortNameLabel = [UILabel new];
    self.shortNameLabel.backgroundColor = UIColor.lightGrayColor;
    self.shortNameLabel.textColor = UIColor.whiteColor;
    self.shortNameLabel.layer.cornerRadius = 20;
    self.shortNameLabel.layer.masksToBounds = true;
    self.shortNameLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutShortNameLabel {
    [self addSubview:self.shortNameLabel];
    self.shortNameLabel.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.shortNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.shortNameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.shortNameLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.shortNameLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
}

@end
