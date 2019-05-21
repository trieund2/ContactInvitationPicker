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
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.centerX.equalTo(self);
    }];
}

- (void)initSubTitleLabel {
    _subTitleLabel = [UILabel new];
    self.subTitleLabel.text = @"Đã chọn: 0";
    [self.subTitleLabel setFont:[UIFont systemFontOfSize:11]];
    self.subTitleLabel.textColor = UIColorFromRGB(0x9AA5AC);
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
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
