//
//  NIContactCellObject.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICellFactory.h"
#import "ContactObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIContactCellObject : NICellObject <ContactObjectProtocol>

@property (nonatomic, copy) NSString *fullNameIgnoreUnicode;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic) UIColor *shortNameBackgroundColor;
@property (nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
