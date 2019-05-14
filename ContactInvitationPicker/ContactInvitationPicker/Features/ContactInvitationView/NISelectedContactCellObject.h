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
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) UIColor *color;

- (id)initWithPhoneNumber:(NSString *)phoneNumber
                 fullName:(NSString *)fullName
                indexPath:(NSIndexPath *)indexPath
                    color:(UIColor *)color;
+ (id)objectWithPhoneNumber:(NSString *)phoneNumber
                   fullName:(NSString *)fullName
                  indexPath:(NSIndexPath *)indexPath
                      color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
