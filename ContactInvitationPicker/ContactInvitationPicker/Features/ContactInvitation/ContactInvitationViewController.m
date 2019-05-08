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

#define MAX_CONTACT_SELECT 5

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSMutableArray *selectedContacts;
    NITableViewModel *contactTableViewModle;
    NSLayoutConstraint *selectContactCollectionViewHeightConst;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    selectedContacts = [NSMutableArray new];
    [self initSelectContactCollectionView];
    [self initSearchBar];
    [self initContactsTableView];
    
    [ContactScan scanContact:^(NSArray * _Nonnull contacts, NSArray * _Nonnull titles) {
        [self configContactTableViewDataSourceWithContacts:contacts titles:titles];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

#pragma mark Init and setupLayout

- (void)initSelectContactCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.selectContactCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.selectContactCollectionView.backgroundColor = UIColorFromRGB(0xE9E9E9);
    self.selectContactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.selectContactCollectionView];
    [self.selectContactCollectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
    [self.selectContactCollectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.selectContactCollectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    selectContactCollectionViewHeightConst = [self.selectContactCollectionView.heightAnchor constraintEqualToConstant:0];
    selectContactCollectionViewHeightConst.active = YES;
}

- (void)initSearchBar {
    self.searchBar = [UISearchBar new];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    [self.view addSubview:self.searchBar];
    [self.searchBar.topAnchor constraintEqualToAnchor:self.selectContactCollectionView.bottomAnchor constant:4].active = YES;
    [self.searchBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.searchBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.searchBar.heightAnchor constraintEqualToConstant:40].active = YES;
}

- (void)initContactsTableView {
    self.contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.contactTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.contactTableView];
    [self.contactTableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:4].active = YES;
    [self.contactTableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.contactTableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.contactTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

#pragma mark Helper methods

- (void)configContactTableViewDataSourceWithContacts:(NSArray *)contacts titles:(NSArray *)titles {
    if (titles.count != contacts.count) { return; }
    NSMutableArray *sectionContacts = [NSMutableArray new];
    
    for (int i = 0; i < titles.count; i++) {
        [sectionContacts addObject:[titles objectAtIndex:i]];
        NSArray *groupContacts = [contacts objectAtIndex:i];
        
        for (Contact *contact in groupContacts) {
            [sectionContacts addObject:[NIContactCellObject objectWithTitle:contact.fullName shortName:contact.shortName]];
        }
    }
    
    contactTableViewModle = [[NITableViewModel alloc] initWithSectionedArray:sectionContacts delegate:(id)[NICellFactory class]];
    self.contactTableView.dataSource = contactTableViewModle;
    [contactTableViewModle setSectionIndexType:NITableViewModelSectionIndexDynamic
                   showsSearch:YES
                  showsSummary:YES];
    [self.contactTableView reloadData];
}

- (void)performAnimateSelectedContactCollectionView {
    CGFloat height = 0;
    if (selectedContacts.count != 0) {
        height = 44;
    }
    if (selectContactCollectionViewHeightConst.constant == height) { return; }
    selectContactCollectionViewHeightConst.constant = height;
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NIContactCellObject *object = [contactTableViewModle objectAtIndexPath:indexPath];
    if ([selectedContacts containsObject:object]) {
        [selectedContacts removeObject:object];
        object.isSelected = NO;
    } else if (selectedContacts.count < MAX_CONTACT_SELECT) {
        [selectedContacts addObject:object];
        object.isSelected = YES;
    } else {
        return;
    }
    [self performAnimateSelectedContactCollectionView];
    [self.contactTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
