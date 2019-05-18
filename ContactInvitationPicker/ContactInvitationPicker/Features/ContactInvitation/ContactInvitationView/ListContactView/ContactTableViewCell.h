//
//  ContactTableViewCell.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"
#import "UIImageView+Letters.h"
#import "ZAContactAvatarCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactTableViewCell : UITableViewCell <NICell>

@property (readonly, nonatomic) UIImageView *checkBoxImageView;
@property (readonly, nonatomic) UILabel *fullNameLabel;
@property (readonly, nonatomic) UIView *separatorView;
@property (readonly, nonatomic) UIImageView *avatarImageView;

@end

NS_ASSUME_NONNULL_END
