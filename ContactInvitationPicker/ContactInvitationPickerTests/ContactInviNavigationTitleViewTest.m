//
//  ContactInviNavigationTitleViewTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ContactInviNavigationTitleView.h"

@interface ContactInviNavigationTitleViewTest : XCTestCase

@end

@implementation ContactInviNavigationTitleViewTest {
    ContactInviNavigationTitleView *sut;
}

- (void)setUp {
    sut = [[ContactInviNavigationTitleView alloc] initWithFrame:(CGRectZero)];
}

- (void)tearDown {
}

- (void)testInitAllPropertyNotNil {
    XCTAssertNotNil(sut.titleLabel);
    XCTAssertNotNil(sut.subTitleLabel);
}

- (void)testUpdateSubTitleSetCorrectValue {
    [sut updateSubTitleWithNumberSelectContacts:2];
    XCTAssertTrue([sut.subTitleLabel.text isEqualToString:@"Đã chọn: 2"]);
}

@end
