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
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.checkBoxImageView
                                                       attribute:(NSLayoutAttributeCenterY)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterY)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.checkBoxImageView
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeLeft)
                                                      multiplier:1
                                                        constant:12],
                          [NSLayoutConstraint constraintWithItem:self.checkBoxImageView
                                                       attribute:(NSLayoutAttributeWidth)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeWidth)
                                                      multiplier:1
                                                        constant:20],
                          [NSLayoutConstraint constraintWithItem:self.checkBoxImageView
                                                       attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:20],
                          nil]];
}

- (void)layoutAvatarImageView {
    [self.contentView addSubview:self.avatarImageView];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeCenterY)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterY)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self.checkBoxImageView
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:14],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeWidth)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeWidth)
                                                      multiplier:1
                                                        constant:46],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:46],
                          nil]];
}

- (void)layoutFullNameLabel {
    [self.contentView addSubview:self.fullNameLabel];
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.fullNameLabel
                                                       attribute:(NSLayoutAttributeCenterY)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterY)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.fullNameLabel
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:14],
                          nil]];
}

- (void)layoutSeparatorLine {
    [self.contentView addSubview:self.separatorLine];
    self.separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.separatorLine
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self.fullNameLabel
                                                       attribute:(NSLayoutAttributeLeft)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorLine
                                                       attribute:(NSLayoutAttributeRight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorLine
                                                       attribute:(NSLayoutAttributeBottom)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeBottom)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorLine
                                                       attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:0.5],
                          nil]];
}

@end
