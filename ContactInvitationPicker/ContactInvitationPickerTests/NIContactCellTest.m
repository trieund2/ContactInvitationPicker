//
//  NIContactCellTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NIContactCell.h"
#import "NIContactCellObject.h"
#import "CNMutableContact+Init.h"

@interface NIContactCellTest : XCTestCase

@end

@implementation NIContactCellTest {
    NIContactCell *sut;
}

- (void)setUp {
    sut = [[NIContactCell alloc] initWithFrame:(CGRectZero)];
}

- (void)tearDown {
}

- (void)testInit_AllProptertyNotNil {
    XCTAssertNotNil(sut.checkBoxImageView);
    XCTAssertNotNil(sut.shortNameLabel);
    XCTAssertNotNil(sut.fullNameLabel);
    XCTAssertNotNil(sut.separatorLine);
}

- (void)testUpdateCellWithNIContactCellObject {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @"Trieu"];
    NIContactCellObject *object = [[NIContactCellObject alloc] initFromContact:contact];
    [sut shouldUpdateCellWithObject: object];
    
    XCTAssertTrue([sut.shortNameLabel.text isEqual:object.shortName]);
    XCTAssertTrue([sut.fullNameLabel.text isEqual:object.displayName]);
    XCTAssertTrue([sut.shortNameLabel.backgroundColor isEqual:object.shortNameBackgroundColor]);
}

@end
