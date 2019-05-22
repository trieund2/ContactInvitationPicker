//
//  ContactTableViewCell.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ContactCellObject.h"
#import "UIColorFromRGB.h"

@implementation ContactTableViewCell {
    ContactCellObject *contactCellObject;
}

#pragma mark Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xE7E9EB);
        self.selectedBackgroundView = view;
        [self initCheckBoxImageView];
        [self initAvatarImageView];
        [self initFullNameLabel];
        [self initSeparatorView];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIImage *avatarImage = [[ZAContactAvatarCache sharedInstance] getImageWithKey:contactCellObject.identifier];
    if (avatarImage) {
        [self.avatarImageView setImage:avatarImage];
    } else if (contactCellObject) {
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor,
                                         NSFontAttributeName: [UIFont systemFontOfSize:20]};
        [self.avatarImageView setImageWithString:contactCellObject.fullNameRemoveDiacritics
                                           color:contactCellObject.shortNameBackgroundColor
                                        circular:YES
                                  textAttributes:textAttributes
                                            size:CGSizeMake(46, 46)];
        [[ZAContactAvatarCache sharedInstance] storeImage:self.avatarImageView.image withKey:contactCellObject.identifier];
    }
}

#pragma mark Instance methods

- (BOOL)shouldUpdateCellWithObject:(ContactCellObject *)object {
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

- (void)initCheckBoxImageView {
    _checkBoxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnCheck"]];
    [self.contentView addSubview:self.checkBoxImageView];
    [self.checkBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)initAvatarImageView {
    _avatarImageView = [UIImageView new];
    [self.avatarImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.checkBoxImageView.mas_right).offset(14);
        make.width.height.mas_equalTo(46);
    }];
}

- (void)initFullNameLabel {
    _fullNameLabel = [UILabel new];
    [self.contentView addSubview:self.fullNameLabel];
    [self.fullNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.avatarImageView.mas_right).offset(14);
    }];
}

- (void)initSeparatorView {
    _separatorView = [UIView new];
    self.separatorView.backgroundColor = UIColorFromRGB(0xF4F5F5);
    [self.contentView addSubview:self.separatorView];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullNameLabel);
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

@end
