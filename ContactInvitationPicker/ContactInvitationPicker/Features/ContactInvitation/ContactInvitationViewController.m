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
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "NISelectedContactCellObject.h"

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
    NITableViewModel *contactTableViewModel;
    NICollectionViewModel *collectionViewModel;
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
    [self layoutSelectContactCollectionView];
    [self layoutSearchBar];
    [self layoutContactTableView];
    
    [ContactScan scanContact:^(NSArray * _Nonnull contacts, NSArray * _Nonnull titles) {
        [self configContactTableViewDataSourceWithContacts:contacts titles:titles];
    } notGranted:^{
        NSLog(@"Not grant access contact");
    }];
}

#pragma mark Init layouts

- (void)initSelectContactCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 4;
    self.selectContactCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    self.selectContactCollectionView.backgroundColor = UIColor.clearColor;
    
    
    collectionViewModel = [[NICollectionViewModel alloc]
                           initWithListArray:selectedContacts
                           delegate:(id)[NICollectionViewCellFactory class]];
    self.selectContactCollectionView.dataSource = collectionViewModel;
    [self.selectContactCollectionView reloadData];
}

- (void)initSearchBar {
    self.searchBar = [UISearchBar new];
    [self.searchBar setBackgroundImage:[UIImage new]];
}

- (void)initContactsTableView {
    self.contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark Setup layouts

- (void)layoutSelectContactCollectionView {
    self.selectContactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectContactCollectionView];
    [self.selectContactCollectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
    [self.selectContactCollectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:8].active = YES;
    [self.selectContactCollectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    selectContactCollectionViewHeightConst = [self.selectContactCollectionView.heightAnchor constraintEqualToConstant:0];
    selectContactCollectionViewHeightConst.active = YES;
}

- (void)layoutSearchBar {
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    [self.searchBar.topAnchor constraintEqualToAnchor:self.selectContactCollectionView.bottomAnchor constant:4].active = YES;
    [self.searchBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.searchBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.searchBar.heightAnchor constraintEqualToConstant:40].active = YES;
}

- (void)layoutContactTableView {
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
    
    contactTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:sectionContacts delegate:(id)[NICellFactory class]];
    self.contactTableView.dataSource = contactTableViewModel;
    [contactTableViewModel setSectionIndexType:NITableViewModelSectionIndexDynamic
                   showsSearch:YES
                  showsSummary:YES];
    [self.contactTableView reloadData];
}

- (void)performAnimateSelectedContactCollectionView {
    CGFloat height = 0;
    if (selectedContacts.count != 0) {
        height = 50;
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
    NIContactCellObject *contactObject = [contactTableViewModel objectAtIndexPath:indexPath];
    NISelectedContactCellObject *selectContactObject = [NISelectedContactCellObject objectWithPhoneNumber:contactObject.phoneNumber shortName:contactObject.shortName];
    
    if ([selectedContacts containsObject:selectContactObject]) {
        [selectedContacts removeObject:selectContactObject];
        contactObject.isSelected = NO;
    } else if (selectedContacts.count < MAX_CONTACT_SELECT) {
        [selectedContacts addObject:selectContactObject];
        contactObject.isSelected = YES;
    } else {
        return;
    }
    
    [self.selectContactCollectionView reloadData];
    [self performAnimateSelectedContactCollectionView];
    [self.contactTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
}

@end
