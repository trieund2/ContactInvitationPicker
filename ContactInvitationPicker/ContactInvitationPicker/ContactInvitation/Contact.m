//
//  Contact.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (id)contactWithFirstName:(NSString *)firstName lastName:(NSString *)lastName phoneNumber:(NSString *)phoneNumber {
    Contact *contact = [Contact new];
    contact.firstName = firstName;
    contact.lastName = lastName;
    contact.phoneNumber = phoneNumber;
    if ([lastName length] == 0) {
        contact.fullName = firstName;
    } else {
        contact.fullName = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
    }
    
    return contact;
}

@end
