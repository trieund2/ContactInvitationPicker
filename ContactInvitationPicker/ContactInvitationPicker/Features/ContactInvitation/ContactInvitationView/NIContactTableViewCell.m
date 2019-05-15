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
    NIContactCellObject *contactCellObject;
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
        _avatarImageView = [UIImageView new];
        self.separatorLine.backgroundColor = UIColorFromRGB(0xF4F5F5);
        [self layoutCheckBoxImageView];
        [self layoutAvatarImageView];
        [self layoutFullNameLabel];
        [self layoutSeparatorLine];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIImage *avatarImage = [[AvatarCacheManager shared] getImageWithKey:contactCellObject.fullNameRemoveDiacritics];
    if (avatarImage) {
        [self.avatarImageView setImage:avatarImage];
    } else if (contactCellObject) {
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor,
                                         NSFontAttributeName: [UIFont systemFontOfSize:20]
                                         };
        [self.avatarImageView setImageWithString:contactCellObject.fullNameRemoveDiacritics
                                           color:contactCellObject.shortNameBackgroundColor
                                        circular:YES
                                  textAttributes:textAttributes
                                            size:CGSizeMake(46, 46)];
        [[AvatarCacheManager shared] storeImage:self.avatarImageView.image withKey:contactCellObject.fullNameRemoveDiacritics];
    }
}

#pragma mark Instance methods

- (BOOL)shouldUpdateCellWithObject:(NIContactCellObject *)object {
    contactCellObject = object;
    [self setNeedsDisplay];
    self.fullNameLabel.text = object.fullName;
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

- (void)layoutAvatarImageView {
    [self.contentView addSubview:self.avatarImageView];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.avatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.avatarImageView.leftAnchor constraintEqualToAnchor:self.checkBoxImageView.rightAnchor constant:14].active = YES;
    [self.avatarImageView.heightAnchor constraintEqualToConstant:46].active = YES;
    [self.avatarImageView.widthAnchor constraintEqualToConstant:46].active = YES;
}

- (void)layoutFullNameLabel {
    [self.contentView addSubview:self.fullNameLabel];
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.fullNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.fullNameLabel.leftAnchor constraintEqualToAnchor:self.avatarImageView.rightAnchor constant:14].active = YES;
}

- (void)layoutSeparatorLine {
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.separatorLine.leftAnchor constraintEqualToAnchor:self.fullNameLabel.leftAnchor].active = YES;
    [self.separatorLine.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.separatorLine.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.separatorLine.heightAnchor constraintEqualToConstant:0.5].active = YES;
}

@end
