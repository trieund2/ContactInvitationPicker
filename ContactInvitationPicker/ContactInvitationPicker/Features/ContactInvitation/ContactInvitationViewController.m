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
#import "NSString+Extension.h"

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
    NSLayoutConstraint *searchBarTopConst;
    UIButton *sendButton;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    selectedContacts = [NSMutableArray new];
    listContact = [NSArray new];
    [self addNavigationBarItems];
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

#pragma mark UI actions

- (void)touchInCancelButton {
    NSLog(@"Did select cancel barbutton");
}

- (void)touchInSendButton {
    NSMutableArray *recipients = [NSMutableArray new];
    for (NISelectedContactCellObject *object in selectedContacts) {
        [recipients addObject:object.phoneNumber];
    }
    MFMessageComposeViewController *messageViewController = [MFMessageComposeViewController new];
    messageViewController.messageComposeDelegate = self;
    messageViewController.recipients = recipients;
    messageViewController.body = @"Moi ban cai dat zalo mien phi";
    [self presentViewController:messageViewController animated:YES completion:^{}];
}

#pragma mark Init layouts

- (void)addNavigationBarItems {
    UIButton *cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelButton setTitle:@"Huỷ" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:UIColorFromRGB(0x595D64) forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(touchInCancelButton)
           forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sendButton setUserInteractionEnabled:NO];
    [sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
    [sendButton addTarget:self action:@selector(touchInSendButton) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
    
    _titleView = [ContactInviNavigationTitleView new];
    self.titleView.frame = CGRectMake(0, 0, 100, 100);
    self.navigationItem.titleView = self.titleView;
}

- (void)initSelectContactCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 4;
    _selectContactCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
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
    _searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self layoutSearchBar];
}

- (void)initContactsTableView {
    _contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self layoutContactTableView];
}

- (void)initSearchReultTableView {
    _searchResultTableView = [UITableView new];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchResultTableView setHidden:YES];
    [self layoutSearchResultTableView];
}

- (void)initEmptySearchResultLabel {
    _emptySearchResultLabel = [UILabel new];
    self.emptySearchResultLabel.text = @"Không tìm thầy kết quả phù hợp";
    [self.emptySearchResultLabel setFont:[UIFont systemFontOfSize:15]];
    [self.emptySearchResultLabel setHidden:YES];
    [self layoutEmptySearchResultLabel];
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
    CGFloat selectedContactCollectionViewHeight = 0;
    CGFloat searchBarTopConstValue = 0;
    if (selectedContacts.count != 0) {
        selectedContactCollectionViewHeight = 40;
        searchBarTopConstValue = 4;
    }
    if (selectContactCollectionViewHeightConst.constant == selectedContactCollectionViewHeight) { return; }
    selectContactCollectionViewHeightConst.constant = selectedContactCollectionViewHeight;
    searchBarTopConst.constant = searchBarTopConstValue;
    
    __weak ContactInvitationViewController *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)performSearchWithSearchText:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) { return; }
    
    NSArray *filteredArray = [listContact filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        if ([object isKindOfClass:[NSString class]]) {
            return NO;
        } else if ([object isKindOfClass:[NIContactCellObject class]]) {
            NIContactCellObject *contactCellObject = (NIContactCellObject *)object;
            return [contactCellObject.displayNameIgnoreUnicode.lowercaseString containsString:[NSString ignoreUnicode:searchText].lowercaseString];
        } else {
            return NO;
        }
    }]];
    
    searchResultTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:filteredArray delegate:(id)[NICellFactory class]];
    self.searchResultTableView.dataSource = searchResultTableViewModel;
    [self.searchResultTableView reloadData];
    [self.emptySearchResultLabel setHidden:(filteredArray.count != 0)];
}

- (void)updateSendButtonState {
    if (selectedContacts.count == 0) {
        [sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
        [sendButton setUserInteractionEnabled:NO];
    } else {
        [sendButton setImage:[UIImage imageNamed:@"Send"] forState:(UIControlStateNormal)];
        [sendButton setUserInteractionEnabled:YES];
    }
}

#pragma mark Setup layouts

- (void)layoutSelectContactCollectionView {
    self.selectContactCollectionView.delegate = self;
    self.selectContactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectContactCollectionView];
    [self.selectContactCollectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:4].active = YES;
    [self.selectContactCollectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:8].active = YES;
    [self.selectContactCollectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    selectContactCollectionViewHeightConst = [self.selectContactCollectionView.heightAnchor constraintEqualToConstant:0];
    selectContactCollectionViewHeightConst.active = YES;
}

- (void)layoutSearchBar {
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    searchBarTopConst = [self.searchBar.topAnchor constraintEqualToAnchor:self.selectContactCollectionView.bottomAnchor];
    [self.searchBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.searchBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.searchBar.heightAnchor constraintEqualToConstant:40].active = YES;
    searchBarTopConst.active = YES;
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
    self.emptySearchResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchResultTableView addSubview:self.emptySearchResultLabel];
    [self.emptySearchResultLabel.centerXAnchor constraintEqualToAnchor:self.searchResultTableView.centerXAnchor].active = YES;
    [self.emptySearchResultLabel.topAnchor constraintEqualToAnchor:self.searchResultTableView.topAnchor constant:70].active = YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    view.backgroundColor = UIColor.whiteColor;
    NSString *title = [contactTableViewModel tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [UILabel new];
    label.text = title;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.textColor = UIColorFromRGB(0x79848F);
    label.frame = CGRectMake(6, 0, 100, 30);
    [view addSubview:label];
    return view;
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
    
    NISelectedContactCellObject *selectContactObject = [NISelectedContactCellObject
                                                        objectWithPhoneNumber:contactObject.phoneNumber
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
        NSString *message = [NSString stringWithFormat:@"%@ %i %@", @"Bạn không được chọn quá", MAX_CONTACT_SELECT, @"người"];
        [self presentAlertWithTitle:@"Thông báo" message:message actions:nil];
        return;
    }
    
    [self.selectContactCollectionView reloadData];
    [self performAnimateSelectedContactCollectionView];
    if (tableView == self.contactTableView) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    }
    [self updateSendButtonState];
    [self.titleView updateSubTitleWithNumberSelecContacts:selectedContacts.count];
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

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

@end
