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
    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:2].active = YES;
    [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
}

- (void)initSubTitleLabel {
    _subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"Đã chọn: 0";
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.subTitleLabel setFont:[UIFont systemFontOfSize:11]];
    self.subTitleLabel.textColor = UIColorFromRGB(0x9AA5AC);
    
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor].active = YES;
    [self.subTitleLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
}

- (void)updateSubTitleWithNumberSelecContacts:(NSUInteger)number {
    NSString *title = [@"Đã chọn: " stringByAppendingString:[NSString stringWithFormat:@"%li", number]];
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
