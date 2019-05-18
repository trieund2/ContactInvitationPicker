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
    UIImage *avatarImage = [[ZAContactAvatarCache sharedInstance] getImageWithKey:contactCellObject.fullNameRemoveDiacritics];
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
        [[ZAContactAvatarCache sharedInstance] storeImage:self.avatarImageView.image withKey:contactCellObject.fullNameRemoveDiacritics];
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

- (void)initAvatarImageView {
    _avatarImageView = [UIImageView new];
    [self.avatarImageView setContentMode:(UIViewContentModeScaleAspectFit)];
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

- (void)initFullNameLabel {
    _fullNameLabel = [UILabel new];
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

- (void)initSeparatorView {
    _separatorView = [UIView new];
    self.separatorView.backgroundColor = UIColorFromRGB(0xF4F5F5);
    [self.contentView addSubview:self.separatorView];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.separatorView
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self.fullNameLabel
                                                       attribute:(NSLayoutAttributeLeft)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorView
                                                       attribute:(NSLayoutAttributeRight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorView
                                                       attribute:(NSLayoutAttributeBottom)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeBottom)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.separatorView
                                                       attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:nil
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:0.5],
                          nil]];
}

@end
