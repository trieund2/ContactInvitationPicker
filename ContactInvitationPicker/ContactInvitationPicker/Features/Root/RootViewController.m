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

#pragma mark - View Lifecycles

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
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.contactInvitationPickerButton
                                                            attribute:(NSLayoutAttributeWidth)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:nil
                                                            attribute:(NSLayoutAttributeWidth)
                                                           multiplier:1
                                                             constant:250],
                               [NSLayoutConstraint constraintWithItem:self.contactInvitationPickerButton
                                                            attribute:(NSLayoutAttributeHeight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:nil
                                                            attribute:(NSLayoutAttributeHeight)
                                                           multiplier:1
                                                             constant:46],
                               [NSLayoutConstraint constraintWithItem:self.contactInvitationPickerButton
                                                            attribute:(NSLayoutAttributeCenterX)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeCenterX)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.contactInvitationPickerButton
                                                            attribute:(NSLayoutAttributeCenterY)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeCenterY)
                                                           multiplier:1
                                                             constant:0],
                               nil]];
}

#pragma mark - UI Actions

- (void)touchInContactInviationPickerButton {
    ContactInvitationViewController *contactInvitationViewController = [ContactInvitationViewController new];
    contactInvitationViewController.delegate = self;
    UINavigationController *contactInviNavigationController = [[UINavigationController alloc] initWithRootViewController:contactInvitationViewController];
    [self presentViewController:contactInviNavigationController animated:YES completion:^{}];
}

#pragma mark - ContactInvitationViewControllerDelegate

- (void)didSelectSendContacts:(NSArray<SelectedContactCellObject *> *)contacts {
    NSMutableArray *recipients = [NSMutableArray new];
    for (SelectedContactCellObject *object in contacts) {
        if (object.phoneNumber != NULL && [object.phoneNumber isKindOfClass:NSString.class]) {
            [recipients addObject:object.phoneNumber];
        }
    }
    MFMessageComposeViewController *messageComposeViewController = [MFMessageComposeViewController new];
    messageComposeViewController.messageComposeDelegate = self;
    messageComposeViewController.recipients = recipients;
    messageComposeViewController.body = @"Moi ban cai dat zalo mien phi";
    [self presentViewController:messageComposeViewController animated:YES completion:^{}];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
