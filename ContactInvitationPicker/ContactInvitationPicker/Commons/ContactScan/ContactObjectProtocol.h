//
//  ContactObjectProtocol.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ContactObjectProtocol <NSObject>

- (id)initFromContact:(CNContact *)contact;
+ (id)objectFromContact:(CNContact *)contact;

@end

NS_ASSUME_NONNULL_END
