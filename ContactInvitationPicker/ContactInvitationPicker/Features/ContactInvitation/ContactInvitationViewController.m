//
//  ViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInvitationViewController.h"
#import "ContactScan.h"
#import "NimbusModels.h"
#import "NIContactCellObject.h"
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "NISelectedContactCellObject.h"
#import "UIColorFromRGB.h"
#import "UIViewController+Alert.h"

#define MAX_CONTACT_SELECT 5

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSArray *listContact;
    NSMutableArray *selectedContacts;
    NITableViewModel *contactTableViewModel;
    NITableViewModel *searchResultTableViewModel;
    NICollectionViewModel *collectionViewModel;
    NSLayoutConstraint *selectContactCollectionViewHeightConst;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    selectedContacts = [NSMutableArray new];
    listContact = [NSArray new];
    [self initSelectContactCollectionView];
    [self initSearchBar];
    [self initContactsTableView];
    [self initSearchReultTableView];
    [self initEmptySearchResultLabel];
    
    [ContactScan scanContact:^(NSArray * _Nonnull contacts) {
        self->listContact = contacts;
        [self configContactTableViewDataSource];
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
    [self layoutSelectContactCollectionView];
}

- (void)initSearchBar {
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self layoutSearchBar];
}

- (void)initContactsTableView {
    self.contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self layoutContactTableView];
}

- (void)initSearchReultTableView {
    self.searchResultTableView = [UITableView new];
    self.searchResultTableView.delegate = self;
    [self.searchResultTableView setHidden:YES];
    self.searchResultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self layoutSearchResultTableView];
}

- (void)initEmptySearchResultLabel {
    self.emptySearchResultLabel = [UILabel new];
    self.emptySearchResultLabel.text = @"Không tìm thầy kết quả phù hợp";
    [self.emptySearchResultLabel setHighlighted:YES];
    [self layoutEmptySearchResultLabel];
}

#pragma mark Setup layouts

- (void)layoutSelectContactCollectionView {
    self.selectContactCollectionView.delegate = self;
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

- (void)layoutSearchResultTableView {
    self.searchResultTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchResultTableView];
    [self.searchResultTableView.topAnchor constraintEqualToAnchor:self.contactTableView.topAnchor].active = YES;
    [self.searchResultTableView.leftAnchor constraintEqualToAnchor:self.contactTableView.leftAnchor].active = YES;
    [self.searchResultTableView.rightAnchor constraintEqualToAnchor:self.contactTableView.rightAnchor].active = YES;
    [self.searchResultTableView.bottomAnchor constraintEqualToAnchor:self.contactTableView.bottomAnchor].active = YES;
}

- (void)layoutEmptySearchResultLabel {
    self.emptySearchResultLabel.translatesAutoresizingMaskIntoConstraints = YES;
    [self.searchResultTableView addSubview:self.emptySearchResultLabel];
    [self.emptySearchResultLabel.centerXAnchor constraintEqualToAnchor:self.searchResultTableView.centerXAnchor].active = YES;
    [self.emptySearchResultLabel.topAnchor constraintEqualToAnchor:self.searchResultTableView.topAnchor constant:60].active = YES;
}

#pragma mark Helper methods

- (void)configContactTableViewDataSource {
    contactTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:listContact delegate:(id)[NICellFactory class]];
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

- (void)performSearchWithSearchText:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) { return; }
    
    NSArray *filteredArray = [listContact filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        if ([object isKindOfClass:[NSString class]]) {
            return NO;
        } else if ([object isKindOfClass:[NIContactCellObject class]]) {
            NIContactCellObject *contactCellObject = (NIContactCellObject *)object;
            return [contactCellObject.displayName containsString:searchText];
        } else {
            return NO;
        }
    }]];
    
    searchResultTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:filteredArray delegate:(id)[NICellFactory class]];
    self.searchResultTableView.dataSource = searchResultTableViewModel;
    [self.searchResultTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NIContactCellObject *contactObject;
    NSIndexPath *selectedIndexPath = indexPath;
    
    if (tableView == self.contactTableView) {
        contactObject = [contactTableViewModel objectAtIndexPath:indexPath];
    } else if (tableView == self.searchResultTableView) {
        contactObject = [searchResultTableViewModel objectAtIndexPath:indexPath];
        selectedIndexPath = [contactTableViewModel indexPathForObject:contactObject];
        self.searchBar.text = @"";
        [self.searchResultTableView setHidden:YES];
    } else {
        return;
    }
    
    NISelectedContactCellObject *selectContactObject = [NISelectedContactCellObject objectWithPhoneNumber:contactObject.phoneNumber
                                                                                                shortName:contactObject.shortName
                                                                                                indexPath:selectedIndexPath
                                                                                                    color:contactObject.color];
    
    if ([selectedContacts containsObject:selectContactObject]) {
        [selectedContacts removeObject:selectContactObject];
        contactObject.isSelected = NO;
    } else if (selectedContacts.count < MAX_CONTACT_SELECT) {
        [selectedContacts addObject:selectContactObject];
        contactObject.isSelected = YES;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self presentAlertWithTitle:@"Thông báo" message:@"Bạn không được chọn quá 5 người" actions:nil];
    }
    
    [self.selectContactCollectionView reloadData];
    [self performAnimateSelectedContactCollectionView];
    if (tableView == self.contactTableView) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NISelectedContactCellObject *selectedObject = [collectionViewModel objectAtIndexPath:indexPath];
    [self.contactTableView selectRowAtIndexPath:selectedObject.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.contactTableView scrollToRowAtIndexPath:selectedObject.indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchResultTableView setHidden:([searchText isEqualToString:@""])];
    [self performSearchWithSearchText:searchText];
}

@end
