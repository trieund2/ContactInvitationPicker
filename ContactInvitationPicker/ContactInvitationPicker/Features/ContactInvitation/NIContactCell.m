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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    return 60;
}

- (BOOL)shouldUpdateCellWithObject:(NIContactCellObject *)object {
    _shortNameLabel.text = object.shortName;
    _fullNameLabel.text = object.title;
    if (object.isSelected) {
        self.checkBoxImageView.image = [UIImage imageNamed:@"Checked"];
    } else {
        self.checkBoxImageView.image = [UIImage imageNamed:@"UnCheck"];
    }
    return YES;
}

- (void)initShortNameLabel {
    _shortNameLabel = [UILabel new];
    _shortNameLabel.backgroundColor = UIColor.grayColor;
    _shortNameLabel.textColor = UIColor.whiteColor;
    _shortNameLabel.layer.cornerRadius = 20;
    _shortNameLabel.layer.masksToBounds = true;
    _shortNameLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutCheckBoxImageView {
    [self addSubview:_checkBoxImageView];
    _checkBoxImageView.translatesAutoresizingMaskIntoConstraints = NO;;
    [_checkBoxImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [_checkBoxImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:12].active = YES;
    [_checkBoxImageView.widthAnchor constraintEqualToConstant:20].active = YES;
    [_checkBoxImageView.heightAnchor constraintEqualToConstant:20].active = YES;
}

- (void)layoutShortNameLabel {
    [self addSubview:_shortNameLabel];
    _shortNameLabel.translatesAutoresizingMaskIntoConstraints = NO;;
    [_shortNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [_shortNameLabel.leftAnchor constraintEqualToAnchor:_checkBoxImageView.rightAnchor constant:14].active = YES;
    [_shortNameLabel.heightAnchor constraintEqualToConstant:40].active = YES;
    [_shortNameLabel.widthAnchor constraintEqualToConstant:40].active = YES;
}

- (void)layoutFullNameLabel {
    [self addSubview:_fullNameLabel];
    _fullNameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_fullNameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [_fullNameLabel.leftAnchor constraintEqualToAnchor:_shortNameLabel.rightAnchor constant:14].active = YES;
}

@end
