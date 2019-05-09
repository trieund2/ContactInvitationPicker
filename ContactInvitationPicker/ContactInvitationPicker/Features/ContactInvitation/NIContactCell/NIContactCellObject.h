//
//  NIContactCellObject.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NICellFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface NIContactCellObject : NICellObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic) BOOL isSelected;

- (id)initWithTitle:(NSString *)title shortName:(NSString *)shortName phoneNumber:(NSString *)phoneNumber;
+ (id)objectWithTitle:(NSString *)title shortName:(NSString *)shortName phoneNumber:(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END
