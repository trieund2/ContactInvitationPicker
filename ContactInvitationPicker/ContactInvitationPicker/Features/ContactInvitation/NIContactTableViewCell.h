//
//  NIContactTableViewCell.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIContactTableViewCell : UITableViewCell <NICell>

@property (readonly, nonatomic) UIImageView *checkBoxImageView;
@property (readonly, nonatomic) UILabel *shortNameLabel;
@property (readonly, nonatomic) UILabel *fullNameLabel;
@property (readonly, nonatomic) UIView *separatorLine;

@end

NS_ASSUME_NONNULL_END
