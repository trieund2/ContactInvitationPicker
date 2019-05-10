//
//  NIContactCell.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactTableViewCell.h"
#import "NIContactCellObject.h"
#import "UIColorFromRGB.h"

@implementation NIContactTableViewCell {
    UIColor *shortNamebackgroundColor;
}

#pragma mark Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xE7E9EB);
        self.selectedBackgroundView = view;
        _checkBoxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnCheck"]];
        _fullNameLabel = [UILabel new];
        _separatorLine = [UIView new];
        self.separatorLine.backgroundColor = UIColorFromRGB(0xF4F5F5);
        [self initShortNameLabel];
        [self layoutCheckBoxImageView];
        [self layoutShortNameLabel];
        [self layoutFullNameLabel];
        [self layoutSeparatorLine];
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
    shortNamebackgroundColor = object.shortNameBackgroundColor;
    self.shortNameLabel.text = object.shortName;
    self.fullNameLabel.text = object.fullName;
    self.shortNameLabel.backgroundColor = object.shortNameBackgroundColor;
    if (object.isSelected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"Checked"];
    } else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"UnCheck"];
    }
    return YES;
}

#pragma mark Override methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.shortNameLabel.backgroundColor = shortNamebackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.shortNameLabel.backgroundColor = shortNamebackgroundColor;
    }
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

- (void)layoutSeparatorLine {
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.separatorLine.leftAnchor constraintEqualToAnchor:self.fullNameLabel.leftAnchor].active = YES;
    [self.separatorLine.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.separatorLine.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.separatorLine.heightAnchor constraintEqualToConstant:1].active = YES;
}

@end
