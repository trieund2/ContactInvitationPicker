//
//  ContactInviNavigationTitleView.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInviNavigationTitleView.h"
#import "UIColorFromRGB.h"

@implementation ContactInviNavigationTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTitleLabel];
        [self initSubTitleLabel];
    }
    return self;
}

- (void)initTitleLabel {
    _titleLabel = [UILabel new];
    self.titleLabel.text = @"Chọn bạn";
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                       attribute:(NSLayoutAttributeTop)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeTop)
                                                      multiplier:1
                                                        constant:2],
                          [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                       attribute:(NSLayoutAttributeCenterX)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterX)
                                                      multiplier:1
                                                        constant:0],
                          nil]];
}

- (void)initSubTitleLabel {
    _subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"Đã chọn: 0";
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.subTitleLabel setFont:[UIFont systemFontOfSize:11]];
    self.subTitleLabel.textColor = UIColorFromRGB(0x9AA5AC);
    [self addSubview:self.subTitleLabel];
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                       attribute:(NSLayoutAttributeTop)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self.titleLabel
                                                       attribute:(NSLayoutAttributeBottom)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.subTitleLabel
                                                       attribute:(NSLayoutAttributeCenterX)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeCenterX)
                                                      multiplier:1
                                                        constant:0],
                          nil]];
}

- (void)updateSubTitleWithNumberSelectContacts:(NSUInteger)number {
    NSString *title = [@"Đã chọn: " stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
    self.subTitleLabel.text = title;
    __weak ContactInviNavigationTitleView *weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.subTitleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.subTitleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

@end
