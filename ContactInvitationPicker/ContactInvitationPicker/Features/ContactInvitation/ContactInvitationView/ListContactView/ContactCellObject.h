//
//  ContactCellObject.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICellFactory.h"
#import "ZAContactAdapterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactCellObject : NICellObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *fullNameRemoveDiacritics;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic) UIColor *shortNameBackgroundColor;
@property (nonatomic) BOOL isSelected;

- (id)initFromContact:(ZAContactAdapterModel *)contact;
+ (id)objectFromContact:(ZAContactAdapterModel *)contact;

@end

NS_ASSUME_NONNULL_END
