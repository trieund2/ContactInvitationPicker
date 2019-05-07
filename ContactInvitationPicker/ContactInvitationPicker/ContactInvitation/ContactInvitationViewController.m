//
//  ViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInvitationViewController.h"
#import "ContactScan.h"
#import "Contact.h"

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSArray<Contact *> *contacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    contacts = [NSArray array];
    [self setupContactTableView];
    [ContactScan scanContact:^(NSArray * _Nonnull contacts) {
        self->contacts = contacts;
        [self->_contactTableView reloadData];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

- (void)setupContactTableView {
    
}

@end
