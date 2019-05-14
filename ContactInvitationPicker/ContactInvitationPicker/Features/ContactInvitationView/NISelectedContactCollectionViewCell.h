//
//  NISelectedContactCollectionViewCell.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"
#import "UIImageView+Letters.h"

NS_ASSUME_NONNULL_BEGIN

@interface NISelectedContactCollectionViewCell : UICollectionViewCell <NICell>

@property (readonly, nonatomic) UIImageView *avatarImageView;

@end

NS_ASSUME_NONNULL_END
