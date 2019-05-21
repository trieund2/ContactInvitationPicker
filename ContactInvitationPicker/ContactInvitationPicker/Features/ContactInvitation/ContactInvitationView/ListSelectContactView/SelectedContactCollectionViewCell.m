//
//  SelectedContactCollectionViewCell.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "SelectedContactCollectionViewCell.h"
#import "SelectedContactCellObject.h"

@implementation SelectedContactCollectionViewCell {
    SelectedContactCellObject *selectedContactCellObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initAvatarImageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *avatarImage = [[ZAContactAvatarCache sharedInstance] getImageWithKey:selectedContactCellObject.fullNameRemoveDiacritics];
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

- (BOOL)shouldUpdateCellWithObject:(SelectedContactCellObject *)object {
    selectedContactCellObject = object;
    [self setNeedsDisplay];
    return YES;
}

- (void)initAvatarImageView {
    _avatarImageView = [UIImageView new];
    [self.avatarImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self addSubview:self.avatarImageView];
    self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeCenterX)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterX)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeCenterY)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterY)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeWidth)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeWidth)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                       attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:0],
                          nil]];
}

@end
