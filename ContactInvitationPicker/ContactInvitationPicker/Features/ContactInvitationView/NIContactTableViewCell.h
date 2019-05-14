//
//  NIContactTableViewCell.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"
#import "UIImageView+Letters.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIContactTableViewCell : UITableViewCell <NICell>

@property (readonly, nonatomic) UIImageView *checkBoxImageView;
@property (readonly, nonatomic) UILabel *fullNameLabel;
@property (readonly, nonatomic) UIView *separatorLine;
@property (readonly, nonatomic) UIImageView *avatarImageView;

@end

NS_ASSUME_NONNULL_END
