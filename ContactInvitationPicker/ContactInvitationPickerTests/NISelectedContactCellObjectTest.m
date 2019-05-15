//
//  NISelectedContactCellObjectTest.m
//  ContactInvitationPickerTests
//
//  Created by MACOS on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NISelectedContactCellObject.h"

@interface NISelectedContactCellObjectTest : XCTestCase

@end

@implementation NISelectedContactCellObjectTest {
    SelectedContactCellObject *sut;
}

- (void)setUp {
}

- (void)tearDown {
}

- (void)testInitWithValidParams {
    sut = [[SelectedContactCellObject alloc] initWithPhoneNumber:@"0386616446"
                                                         shortName:@"NT"
                                                         indexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                             color:UIColor.whiteColor];
    XCTAssertTrue([sut.phoneNumber isEqualToString:@"0386616446"]);
    XCTAssertTrue([sut.shortName isEqualToString:@"NT"]);
    XCTAssertTrue([sut.contactIndexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]);
    XCTAssertTrue([sut.color isEqual:UIColor.whiteColor]);
}

- (void)testObjectWithValidParams{
    sut = [SelectedContactCellObject objectWithPhoneNumber:@"0386616446"
                                                   shortName:@"NT"
                                                   indexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                                       color:UIColor.whiteColor];
    XCTAssertTrue([sut.phoneNumber isEqualToString:@"0386616446"]);
    XCTAssertTrue([sut.shortName isEqualToString:@"NT"]);
    XCTAssertTrue([sut.contactIndexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]]);
    XCTAssertTrue([sut.color isEqual:UIColor.whiteColor]);
}

@end
