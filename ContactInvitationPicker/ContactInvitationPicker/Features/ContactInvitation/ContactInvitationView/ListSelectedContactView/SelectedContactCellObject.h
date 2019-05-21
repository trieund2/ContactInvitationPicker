//
//  NISelectedContactCellObject.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICollectionViewCellFactory.h"
#import "ContactCellObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectedContactCellObject : NICollectionViewCellObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *fullNameRemoveDiacritics;
@property (nonatomic) NSIndexPath *contactIndexPath;
@property (nonatomic) UIColor *color;

- (id)initWithContactCellObject:(ContactCellObject*)contactCellObject contactIndexPath:(NSIndexPath*)contactIndexPath;
+ (id)objectWithContactCellObject:(ContactCellObject*)contactCellObject contactIndexPath:(NSIndexPath*)contactIndexPath;

@end

NS_ASSUME_NONNULL_END
