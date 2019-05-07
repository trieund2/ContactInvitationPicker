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
#import "NimbusModels.h"

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSArray<Contact *> *_contacts;
    NITableViewModel *_model;
}

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    _model = [[NITableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
    _contacts = [NSArray array];
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ContactScan scanContact:^(NSArray * _Nonnull contacts) {
        self->_contacts = contacts;
        [self configContactTableViewDataSource];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

#pragma mark Private methods

- (void)configContactTableViewDataSource {
    NSMutableArray *arrayContact = [NSMutableArray array];
    for (Contact *contact in _contacts) {
        [arrayContact addObject:[NITitleCellObject objectWithTitle:contact.fullName]];
    }
    _model = [[NITableViewModel alloc] initWithListArray:arrayContact
                                                delegate:(id)[NICellFactory class]];
    _contactTableView.dataSource = _model;
    [_model setSectionIndexType:NITableViewModelSectionIndexAlphabetical
                    showsSearch:YES
                   showsSummary:YES];
}

@end
