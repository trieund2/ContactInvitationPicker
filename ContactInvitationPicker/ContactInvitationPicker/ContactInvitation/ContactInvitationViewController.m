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
    NSArray *_contacts;
    NSArray *_titles;
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
    [ContactScan scanContact:^(NSArray * _Nonnull contacts, NSArray * _Nonnull titles) {
        self->_contacts = contacts;
        self->_titles = titles;
        [self configContactTableViewDataSource];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

#pragma mark Private methods

- (void)configContactTableViewDataSource {
    if (_titles.count != _contacts.count) { return; };
    NSMutableArray *arrayContact = [NSMutableArray new];
    
    for (int i = 0; i < _titles.count; i++) {
        NSArray *contacts = [_contacts objectAtIndex:i];
        [arrayContact addObject:[_titles objectAtIndex:i]];
        for (Contact *contact in contacts) {
            [arrayContact addObject:[NITitleCellObject objectWithTitle:contact.fullName]];
        }
    }
    
    _model = [[NITableViewModel alloc] initWithSectionedArray:arrayContact
                                                     delegate:(id)[NICellFactory class]];
    _contactTableView.dataSource = _model;
    [_model setSectionIndexType:NITableViewModelSectionIndexDynamic
                    showsSearch:YES
                   showsSummary:YES];
}

@end
