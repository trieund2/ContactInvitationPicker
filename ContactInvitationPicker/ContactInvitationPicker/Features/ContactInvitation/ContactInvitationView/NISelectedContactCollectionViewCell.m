//
//  NISelectedContactCollectionViewCell.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NISelectedContactCollectionViewCell.h"
#import "NISelectedContactCellObject.h"

@implementation NISelectedContactCollectionViewCell {
    NISelectedContactCellObject *selectedContactCellObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAvatarImageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *avatarImage = [[AvatarCacheManager shared] getImageWithKey:selectedContactCellObject.fullNameRemoveDiacritics];
    if (avatarImage) {
        [self.avatarImageView setImage:avatarImage];
    } else if (selectedContactCellObject) {
        NSDictionary *textAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor,
                                         NSFontAttributeName: [UIFont systemFontOfSize:16]
                                         };
        [self.avatarImageView setImageWithString:selectedContactCellObject.fullNameRemoveDiacritics
                                           color:selectedContactCellObject.color
                                        circular:YES
                                  textAttributes:textAttributes
                                            size:CGSizeMake(40, 40)];
    }
}

- (BOOL)shouldUpdateCellWithObject:(NISelectedContactCellObject *)object {
    selectedContactCellObject = object;
    [self setNeedsDisplay];
    return YES;
}
- (void)initAvatarImageView {
    _avatarImageView = [UIImageView new];
    [self addSubview:self.avatarImageView];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;;
    [self.avatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.avatarImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.avatarImageView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    [self.avatarImageView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
}

@end
