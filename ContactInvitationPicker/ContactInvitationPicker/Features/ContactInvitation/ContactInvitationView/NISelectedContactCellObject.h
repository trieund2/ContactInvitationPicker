//
//  NISelectedContactCellObject.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICollectionViewCellFactory.h"
#import "NIContactCellObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NISelectedContactCellObject : NICollectionViewCellObject

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *fullNameRemoveDiacritics;
@property (nonatomic) NSIndexPath *contactIndexPath;
@property (nonatomic) UIColor *color;

- (id)initWithContactCellObject:(NIContactCellObject*)contactCellObject indexPath:(NSIndexPath*)indexPath;
+ (id)objectWithContactCellObject:(NIContactCellObject*)contactCellObject indexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
