//
//  NIContactCell.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCell.h"
#import "NIContactCellObject.h"
#import "UIColorFromRGB.h"

@implementation NIContactCell

#pragma mark Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _checkBoxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnCheck"]];
        _fullNameLabel = [UILabel new];
        [self initShortNameLabel];
        [self layoutCheckBoxImageView];
        [self layoutShortNameLabel];
        [self layoutFullNameLabel];
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xE7E9EB);
        self.selectedBackgroundView = view;
    }
    return self;
}

- (void)initShortNameLabel {
    _shortNameLabel = [UILabel new];
    self.shortNameLabel.textColor = UIColor.whiteColor;
    self.shortNameLabel.layer.cornerRadius = 23;
    self.shortNameLabel.layer.masksToBounds = true;
    self.shortNameLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark Instance methods

- (BOOL)shouldUpdateCellWithObject:(NIContactCellObject *)object {
    self.shortNameLabel.text = object.shortName;
    self.fullNameLabel.text = object.displayName;
    self.shortNameLabel.backgroundColor = object.color;
    if (object.isSelected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"Checked"];
    } else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"UnCheck"];
    }
    return YES;
}

#pragma mark Setup layouts

- (void)layoutCheckBoxImageView {
    [self.contentView addSubview:self.checkBoxImageView];
    self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.checkBoxImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.checkBoxImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:12].active = YES;
    [self.checkBoxImageView.widthAnchor constraintEqualToConstant:20].active = YES;
    [self.checkBoxImageView.heightAnchor constraintEqualToConstant:20].active = YES;
}

- (void)layoutShortNameLabel {
    [self.contentView addSubview:self.shortNameLabel];
    self.shortNameLabel.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.shortNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.shortNameLabel.leftAnchor constraintEqualToAnchor:self.checkBoxImageView.rightAnchor constant:14].active = YES;
    [self.shortNameLabel.heightAnchor constraintEqualToConstant:46].active = YES;
    [self.shortNameLabel.widthAnchor constraintEqualToConstant:46].active = YES;
}

- (void)layoutFullNameLabel {
    [self.contentView addSubview:self.fullNameLabel];
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.fullNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.fullNameLabel.leftAnchor constraintEqualToAnchor:self.shortNameLabel.rightAnchor constant:14].active = YES;
}

@end
