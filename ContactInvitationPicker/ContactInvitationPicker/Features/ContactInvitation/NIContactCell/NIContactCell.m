//
//  NIContactCell.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NIContactCell.h"
#import "NIContactCellObject.h"

@implementation NIContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _checkBoxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnCheck"]];
        _fullNameLabel = [UILabel new];
        [self initShortNameLabel];
        [self layoutCheckBoxImageView];
        [self layoutShortNameLabel];
        [self layoutFullNameLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(NIContactCellObject *)object {
    self.shortNameLabel.text = object.shortName;
    self.fullNameLabel.text = object.title;
    if (object.isSelected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"Checked"];
    } else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"UnCheck"];
    }
    return YES;
}

- (void)initShortNameLabel {
    _shortNameLabel = [UILabel new];
    self.shortNameLabel.backgroundColor = UIColor.grayColor;
    self.shortNameLabel.textColor = UIColor.whiteColor;
    self.shortNameLabel.layer.cornerRadius = 20;
    self.shortNameLabel.layer.masksToBounds = true;
    self.shortNameLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutCheckBoxImageView {
    [self addSubview:self.checkBoxImageView];
    self.checkBoxImageView.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.checkBoxImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.checkBoxImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:12].active = YES;
    [self.checkBoxImageView.widthAnchor constraintEqualToConstant:20].active = YES;
    [self.checkBoxImageView.heightAnchor constraintEqualToConstant:20].active = YES;
}

- (void)layoutShortNameLabel {
    [self addSubview:self.shortNameLabel];
    self.shortNameLabel.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.shortNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.shortNameLabel.leftAnchor constraintEqualToAnchor:self.checkBoxImageView.rightAnchor constant:14].active = YES;
    [self.shortNameLabel.heightAnchor constraintEqualToConstant:40].active = YES;
    [self.shortNameLabel.widthAnchor constraintEqualToConstant:40].active = YES;
}

- (void)layoutFullNameLabel {
    [self addSubview:self.fullNameLabel];
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.fullNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.fullNameLabel.leftAnchor constraintEqualToAnchor:self.shortNameLabel.rightAnchor constant:14].active = YES;
}

@end
