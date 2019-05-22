//
//  CNMutableContact+Init.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "CNMutableContact+Init.h"

@implementation CNMutableContact (Init)

- (id)initPhoneNumbers:(NSArray<CNLabeledValue<CNPhoneNumber *> *> *)phoneNumbers
            familyName:(NSString *)familyName
             givenName:(NSString *)givenName
{
    if (self = [super init]) {
        self.phoneNumbers = phoneNumbers;
        self.familyName = familyName;
        self.givenName = givenName;
    }
    
    return self;
}

+ (id)contactPhoneNumbers:(NSArray<CNLabeledValue<CNPhoneNumber *> *> *)phoneNumbers
               familyName:(NSString *)familyName
                givenName:(NSString *)givenName
{
    return [[self alloc] initPhoneNumbers:phoneNumbers familyName:familyName givenName:givenName];
}

@end
