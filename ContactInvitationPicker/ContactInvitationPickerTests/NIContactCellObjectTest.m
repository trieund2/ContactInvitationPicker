//
//  NIContactCellObjectTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NIContactCellObject.h"
#import "CNMutableContact+Init.h"

@interface NIContactCellObjectTest : XCTestCase

@end

@implementation NIContactCellObjectTest {
    NIContactCellObject *sut;
}

- (void)setUp {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @"Trieu"];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
}

- (void)tearDown {
}

- (void)testInit_WithEmptyPhoneContact_RetrurnNil {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@""
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @"Trieu"];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
    XCTAssertNil(sut);
}

- (void)testInit_WithEmptyFamilyNameAndGiven_ReturnNil {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@""
                                                              givenName: @""];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
    XCTAssertNil(sut);
}

- (void)testInit_WithValidFamilyAndEmptyGivenName_ReturnCorrect {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @""];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
    
    XCTAssertNotNil(sut);
    XCTAssertTrue([sut.phoneNumber isEqualToString:@"0386616446"]);
    XCTAssertTrue([sut.displayName isEqualToString:@"Nguyen"]);
    XCTAssertTrue([sut.shortName isEqualToString:@"N"]);
}

- (void)testInit_WithEmptyFamilyAndValidGivenName_ReturnCorrect {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@""
                                                              givenName: @"Trieu"];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
    
    XCTAssertNotNil(sut);
    XCTAssertTrue([sut.phoneNumber isEqualToString:@"0386616446"]);
    XCTAssertTrue([sut.displayName isEqualToString:@"Trieu"]);
    XCTAssertTrue([sut.shortName isEqualToString:@"T"]);
}

- (void)testInit_WithValidFamilyAndGivenName_ReturnCorrect {
    CNMutableContact *contact = [CNMutableContact objectFromPhoneNumber:@"0386616446"
                                                                  label:@"Me"
                                                             familyName:@"Nguyen"
                                                              givenName: @"Trieu"];
    sut = [[NIContactCellObject alloc] initFromContact:contact];
    
    XCTAssertNotNil(sut);
    XCTAssertTrue([sut.phoneNumber isEqualToString:@"0386616446"]);
    XCTAssertTrue([sut.displayName isEqualToString:@"Nguyen Trieu"]);
    XCTAssertTrue([sut.shortName isEqualToString:@"NT"]);
}


- (void)testInit_FromValidContact_AllPropertyNotNil {
    XCTAssertNotNil(sut.displayNameIgnoreUnicode);
    XCTAssertNotNil(sut.displayName);
    XCTAssertNotNil(sut.shortName);
    XCTAssertNotNil(sut.phoneNumber);
}

@end
