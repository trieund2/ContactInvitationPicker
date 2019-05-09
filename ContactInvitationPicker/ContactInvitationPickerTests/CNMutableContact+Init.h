//
//  CNMutableContact+Init.h
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNMutableContact (Init)

- (id)initFromPhoneNumber:(NSString *)phoneNumber
                    label:(NSString *)label
               familyName:(NSString *)familyName
                givenName: (NSString *)givenName;

+ (id)objectFromPhoneNumber:(NSString *)phoneNumber
                    label:(NSString *)label
               familyName:(NSString *)familyName
                givenName: (NSString *)givenName;

@end

NS_ASSUME_NONNULL_END
