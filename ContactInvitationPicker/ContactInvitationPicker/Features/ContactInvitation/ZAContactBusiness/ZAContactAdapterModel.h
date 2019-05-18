//
//  ZAContactAdapterModel.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZAContact.h"
#import "NSString+Extension.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactAdapterModel : NSObject

@property (nonatomic, readonly, copy) NSString *givenName;
@property (nonatomic, readonly, copy) NSString *middleName;
@property (nonatomic, readonly, copy) NSString *familyName;
@property (nonatomic, readonly, copy) NSString *fullName;
@property (nonatomic, readonly, copy) NSString *fullNameRemoveDiacritics;
@property (nonatomic, readonly) NSArray *phoneNumbers;

- (nullable id)initWithZaContact:(ZAContact *)zaContact;
+ (nullable id)objectWithZaContact:(ZAContact *)zaContact;

@end

NS_ASSUME_NONNULL_END
