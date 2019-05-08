//
//  NibSelectedContactCell.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface NibSelectedContactCell : UICollectionViewCell <NICell>

@property (readonly, nonatomic) UILabel *shortNameLabel;

@end

NS_ASSUME_NONNULL_END
