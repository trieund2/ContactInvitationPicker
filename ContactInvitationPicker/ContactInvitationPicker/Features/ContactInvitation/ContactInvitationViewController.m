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
#import "NIContactCellObject.h"

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSArray *contacts;
    NSArray *titles;
    NITableViewModel *model;
}

#pragma mark Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    model = [[NITableViewModel alloc] initWithDelegate:(id)[NICellFactory class]];
    contacts = [NSArray array];
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactTableView.delegate = self;
    [ContactScan scanContact:^(NSArray * _Nonnull contacts, NSArray * _Nonnull titles) {
        self->contacts = contacts;
        self->titles = titles;
        [self configContactTableViewDataSource];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

#pragma mark Private methods

- (void)configContactTableViewDataSource {
    if (titles.count != contacts.count) { return; };
    NSMutableArray *sectionContacts = [NSMutableArray new];
    
    for (int i = 0; i < titles.count; i++) {
        [sectionContacts addObject:[titles objectAtIndex:i]];
        NSArray *groupContacts = [contacts objectAtIndex:i];
        
        for (Contact *contact in groupContacts) {
            [sectionContacts addObject:[NIContactCellObject objectWithTitle:contact.fullName shortName:contact.shortName]];
        }
    }
    
    model = [[NITableViewModel alloc] initWithSectionedArray:sectionContacts delegate:(id)[NICellFactory class]];
    _contactTableView.dataSource = model;
    [model setSectionIndexType:NITableViewModelSectionIndexDynamic
                    showsSearch:YES
                   showsSummary:YES];
    [_contactTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
