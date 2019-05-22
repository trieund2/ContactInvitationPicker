//
//  NIContactCellTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContactTableViewCell.h"
#import "ContactCellObject.h"
#import "CNMutableContact+Init.h"

@interface ContactTableViewCelTest : XCTestCase

@end

@implementation ContactTableViewCelTest {
    ContactTableViewCell *sut;
}

- (void)setUp {
    sut = [[ContactTableViewCell alloc] initWithFrame:(CGRectZero)];
}

- (void)tearDown {
}

- (void)testInit_AllProptertyNotNil {
    XCTAssertNotNil(sut.checkBoxImageView);
    XCTAssertNotNil(sut.avatarImageView);
    XCTAssertNotNil(sut.fullNameLabel);
    XCTAssertNotNil(sut.separatorView);
}

- (void)testUpdateCellWithNIContactCellObject {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @"Trieu"];
    ZAContact *zaContact = [ZAContact objectFromContact:contact];
    ZAContactAdapterModel *model = [ZAContactAdapterModel objectWithZaContact:zaContact];
    ContactCellObject *object = [[ContactCellObject alloc] initFromContact:model];
    [sut shouldUpdateCellWithObject: object];
}

@end
