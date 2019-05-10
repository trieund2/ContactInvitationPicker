//
//  RootViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/10/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _contactInvitationPickerButton = [UIButton new];
    self.contactInvitationPickerButton.backgroundColor = UIColorFromRGB(0x2294FF);
    [self.contactInvitationPickerButton addTarget:self
                                           action:@selector(touchInContactInviationPickerButton)
                                 forControlEvents:(UIControlEventTouchUpInside)];
    [self.contactInvitationPickerButton setTitle:@"Giới thiệu Zalo cho bạn bè" forState:(UIControlStateNormal)];
    [self.contactInvitationPickerButton setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    self.contactInvitationPickerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contactInvitationPickerButton];
    [self.contactInvitationPickerButton.widthAnchor constraintEqualToConstant:250].active = YES;
    [self.contactInvitationPickerButton.heightAnchor constraintEqualToConstant:46].active = YES;
    [self.contactInvitationPickerButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.contactInvitationPickerButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)touchInContactInviationPickerButton {
    ContactInvitationViewController *contactInvitationViewController = [ContactInvitationViewController new];
    UINavigationController *contactInviNavigationController = [[UINavigationController alloc] initWithRootViewController:contactInvitationViewController];
    [self presentViewController:contactInviNavigationController animated:YES completion:^{}];
}


@end
