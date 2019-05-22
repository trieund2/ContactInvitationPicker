//
//  CNContactStoreMock.m
//  ContactInvitationPickerTests
//
//  Created by CPU12202 on 5/22/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "CNContactStoreMock.h"

@implementation CNContactStoreMock

+ (CNAuthorizationStatus)authorizationStatusForEntityType:(CNEntityType)entityType {
    return CNAuthorizationStatusAuthorized;
}

@end
