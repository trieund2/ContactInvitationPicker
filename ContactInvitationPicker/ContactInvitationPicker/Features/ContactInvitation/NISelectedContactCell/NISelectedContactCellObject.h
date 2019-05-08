//
//  NISelectedContactCellObject.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICollectionViewCellFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface NISelectedContactCellObject : NICollectionViewCellObject

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSIndexPath *indexPath;

- (id)initWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName;
+ (id)objectWithPhoneNumber:(NSString *)phoneNumber shortName:(NSString *)shortName;

@end

NS_ASSUME_NONNULL_END
