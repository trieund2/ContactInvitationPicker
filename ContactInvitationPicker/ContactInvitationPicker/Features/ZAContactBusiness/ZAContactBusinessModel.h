//
//  ZAContactBusinessModel.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAContactBusinessModel : NSObject

@property (nonatomic, readonly,copy) NSString *givenName;
@property (nonatomic, readonly, copy) NSString *middleName;
@property (nonatomic, readonly, copy) NSString *familyName;
@property (nonatomic, readonly, copy) NSString *fullName;
@property (nonatomic, readonly, copy) NSString *shortName;
@property (nonatomic, readonly, copy) NSString *fullNameIgnoreUnicode;
@property (nonatomic, readonly) NSArray *phoneNumbers;

@end

NS_ASSUME_NONNULL_END
