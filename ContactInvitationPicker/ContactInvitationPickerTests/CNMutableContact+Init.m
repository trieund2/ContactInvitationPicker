//
//  CNMutableContact+Init.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "CNMutableContact+Init.h"

@implementation CNMutableContact (Init)

- (id)initFromPhoneNumber:(NSString *)phoneNumber
                    label:(NSString *)label
               familyName:(NSString *)familyName
                givenName:(NSString *)givenName {
    
    if (self = [super init]) {
        CNPhoneNumber *cnPhoneNumber = [CNPhoneNumber phoneNumberWithStringValue:phoneNumber];
        self.phoneNumbers = [NSArray arrayWithObject:[[CNLabeledValue alloc] initWithLabel:label
                                                                                     value:cnPhoneNumber]];
        self.familyName = familyName;
        self.givenName = givenName;
    }
    return self;
}

+ (id)objectFromPhoneNumber:(NSString *)phoneNumber
                      label:(NSString *)label
                 familyName:(NSString *)familyName
                  givenName:(NSString *)givenName {
    return  [[self alloc] initFromPhoneNumber:phoneNumber label:label familyName:familyName givenName:givenName];
}

@end
