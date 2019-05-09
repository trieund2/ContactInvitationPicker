//
//  NISelectedContactCellTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NISelectedContactCellObject.h"
#import "NISelectedContactCell.h"

@interface NISelectedContactCellTest : XCTestCase

@end

@implementation NISelectedContactCellTest {
    NISelectedContactCell *sut;
}

- (void)setUp {
   sut = [[NISelectedContactCell alloc] initWithFrame:(CGRectZero)];
}

- (void)tearDown {
}

- (void)testShouldUpdateCell {
    NISelectedContactCellObject *object = [NISelectedContactCellObject objectWithPhoneNumber:@"0386616446" shortName:@"NT" indexPath:[NSIndexPath indexPathForRow:0 inSection:0] color:UIColor.whiteColor];
    [sut shouldUpdateCellWithObject:object];
    XCTAssertTrue([sut.shortNameLabel.text isEqualToString:@"NT"]);
    XCTAssertTrue([sut.shortNameLabel.backgroundColor isEqual:UIColor.whiteColor]);
}

@end
