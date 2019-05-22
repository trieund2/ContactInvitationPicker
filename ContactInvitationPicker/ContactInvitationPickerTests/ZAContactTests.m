//
//  ZAContactTests.m
//  ContactInvitationPickerTests
//
//  Created by CPU12202 on 5/22/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZAContact.h"
#import "CNMutableContact+Init.h"

@interface ZAContactTests : XCTestCase
@property ZAContact *sut;
@end

@implementation ZAContactTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testInitZAContactFromNULLCNContact {
    self.sut = [ZAContact objectFromContact:NULL];
    XCTAssertNil(self.sut);
}

- (void)testInitZAContactFromCNContactWithEmptyPhoneNumber {
    CNLabeledValue<CNPhoneNumber *> *phoneNumber = [[CNLabeledValue alloc] initWithLabel:@"myphone" value:[CNPhoneNumber phoneNumberWithStringValue:@""]];
    CNMutableContact *contact = [CNMutableContact contactPhoneNumbers:[NSArray arrayWithObject:phoneNumber] familyName:@"Nguyen" givenName:@"Trieu"];
    self.sut = [ZAContact objectFromContact:contact];
    XCTAssertNil(self.sut);
}

- (void)testInitZaContactFromFromCNContactEquality {
    CNLabeledValue<CNPhoneNumber *> *phoneNumber = [[CNLabeledValue alloc] initWithLabel:@"myphone"
                                                                                   value:[CNPhoneNumber phoneNumberWithStringValue:@"01386616446"]];
    CNMutableContact *contact = [CNMutableContact contactPhoneNumbers:[NSArray arrayWithObject:phoneNumber] familyName:@"Nguyen" givenName:@"Trieu"];
    self.sut = [ZAContact objectFromContact:contact];
    XCTAssertNotNil(self.sut);
    XCTAssertTrue([self.sut.phoneNumbers isEqual:@[phoneNumber.value.stringValue]]);
    XCTAssertEqual(self.sut.familyName, contact.familyName);
    XCTAssertEqual(self.sut.givenName, contact.givenName);
}

- (void)testInitZaContactFromCNContactWithArrayPhoneNumber {
    CNLabeledValue<CNPhoneNumber *> *phoneNumber1 = [[CNLabeledValue alloc] initWithLabel:@"myphone1"
                                                                                   value:[CNPhoneNumber phoneNumberWithStringValue:@"01386616446"]];
    CNLabeledValue<CNPhoneNumber *> *phoneNumber2 = [[CNLabeledValue alloc] initWithLabel:@"myphone2"
                                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:@"08232837283"]];
    CNMutableContact *contact = [CNMutableContact contactPhoneNumbers:[NSArray arrayWithObjects:phoneNumber1, phoneNumber2, nil]
                                                           familyName:@"Nguyen" givenName:@"Trieu"];
    NSArray<NSString *> *expectPhoneNumbers = [NSArray arrayWithObjects:phoneNumber1.value.stringValue, phoneNumber2.value.stringValue, nil];
    self.sut = [ZAContact objectFromContact:contact];
    XCTAssertNotNil(self.sut);
    XCTAssertTrue([self.sut.phoneNumbers isEqual:expectPhoneNumbers]);
    XCTAssertEqual(self.sut.familyName, contact.familyName);
    XCTAssertEqual(self.sut.givenName, contact.givenName);
}

@end
