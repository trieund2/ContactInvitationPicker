//
//  ViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInvitationViewController.h"
#import "ZAContactScaner.h"
#import "NimbusModels.h"
#import "NIContactCellObject.h"
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "NISelectedContactCellObject.h"
#import "UIColorFromRGB.h"
#import "UIViewController+Alert.h"
#import "NSString+Extension.h"

NSUInteger const kMaxContactSelect = 5;

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSMutableArray<NIContactCellObject *> *listContactCellObject;
    NSMutableArray<NISelectedContactCellObject *> *selectedContactCellObjects;
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
    listContactCellObject = [NSMutableArray new];
    selectedContactCellObjects = [NSMutableArray new];
    _zaContactBusiness = [ZAContactBusiness new];
    [self addNavigationBarItems];
    [self initSelectContactCollectionView];
    [self initSearchBar];
    [self initContactsTableView];
    [self initSearchResultTableView];
    [self initEmptySearchResultLabel];
    [self getAllContacts];
}

#pragma mark UI actions

- (void)touchInCancelButton {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchInSendButton {
    NSMutableArray *recipients = [NSMutableArray new];
    for (NISelectedContactCellObject *object in selectedContactCellObjects) {
        if (object.phoneNumber != NULL) {
            [recipients addObject:object.phoneNumber];
        }
    }
    MFMessageComposeViewController *messageComposeViewController = [MFMessageComposeViewController new];
    messageComposeViewController.messageComposeDelegate = self;
    messageComposeViewController.recipients = recipients;
    messageComposeViewController.body = @"Moi ban cai dat zalo mien phi";
    [self presentViewController:messageComposeViewController animated:YES completion:^{}];
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
    
    _contactInvitationNavigationTitleView = [ContactInviNavigationTitleView new];
    self.contactInvitationNavigationTitleView.frame = CGRectMake(0, 0, 100, 100);
    self.navigationItem.titleView = self.contactInvitationNavigationTitleView;
}

- (void)initSelectContactCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 4;
    _selectContactCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.selectContactCollectionView.backgroundColor = UIColor.clearColor;
    collectionViewModel = [[NICollectionViewModel alloc]
                           initWithListArray:selectedContactCellObjects
                           delegate:(id)[NICollectionViewCellFactory class]];
    self.selectContactCollectionView.dataSource = collectionViewModel;
    self.selectContactCollectionView.delegate = self;
    
    self.selectContactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.selectContactCollectionView];
    [self.selectContactCollectionView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:4].active = YES;
    [self.selectContactCollectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:8].active = YES;
    [self.selectContactCollectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    selectContactCollectionViewHeightConst = [self.selectContactCollectionView.heightAnchor constraintEqualToConstant:0];
    selectContactCollectionViewHeightConst.active = YES;
}

- (void)initSearchBar {
    _searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    searchBarTopConst = [self.searchBar.topAnchor constraintEqualToAnchor:self.selectContactCollectionView.bottomAnchor];
    [self.searchBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.searchBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.searchBar.heightAnchor constraintEqualToConstant:40].active = YES;
    searchBarTopConst.active = YES;
}

- (void)initContactsTableView {
    _contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contactTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contactTableView];
    [self.contactTableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:4].active = YES;
    [self.contactTableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.contactTableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.contactTableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)initSearchResultTableView {
    _searchResultTableView = [UITableView new];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchResultTableView setHidden:YES];
    
    self.searchResultTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchResultTableView];
    [self.searchResultTableView.topAnchor constraintEqualToAnchor:self.contactTableView.topAnchor].active = YES;
    [self.searchResultTableView.leftAnchor constraintEqualToAnchor:self.contactTableView.leftAnchor].active = YES;
    [self.searchResultTableView.rightAnchor constraintEqualToAnchor:self.contactTableView.rightAnchor].active = YES;
    [self.searchResultTableView.bottomAnchor constraintEqualToAnchor:self.contactTableView.bottomAnchor].active = YES;
}

- (void)initEmptySearchResultLabel {
    _emptySearchResultLabel = [UILabel new];
    self.emptySearchResultLabel.text = @"Không tìm thầy kết quả phù hợp";
    [self.emptySearchResultLabel setFont:[UIFont systemFontOfSize:15]];
    [self.emptySearchResultLabel setHidden:YES];
    
    self.emptySearchResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchResultTableView addSubview:self.emptySearchResultLabel];
    [self.emptySearchResultLabel.centerXAnchor constraintEqualToAnchor:self.searchResultTableView.centerXAnchor].active = YES;
    [self.emptySearchResultLabel.topAnchor constraintEqualToAnchor:self.searchResultTableView.topAnchor constant:70].active = YES;
}

#pragma mark Helper methods

- (void)getAllContacts {
    __weak ContactInvitationViewController *weakSelf = self;
    [self.zaContactBusiness getAllContactsFromLocalWithSortType:(ZAContactSortTypeFamilyName) completionHandler:^{
        NSArray *results = [weakSelf.zaContactBusiness mapTitleAndContacts];
        for (id object in results) {
            if ([object isKindOfClass:NSString.class]) {
                [self->listContactCellObject addObject:object];
            } else if ([object isKindOfClass:ZAContactBusinessModel.class]) {
                [self->listContactCellObject addObject:[NIContactCellObject objectFromContact:(ZAContactBusinessModel *)object]];
            }
        }
        
        self->contactTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:self->listContactCellObject
                                                                              delegate:(id)[NICellFactory class]];
        weakSelf.contactTableView.dataSource = self->contactTableViewModel;
        [self->contactTableViewModel setSectionIndexType:(NITableViewModelSectionIndexDynamic)
                                             showsSearch:YES
                                            showsSummary:YES];
        [weakSelf.contactTableView reloadData];
    } errorHandler:^(ZAContactError error) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *remindLaterAction = [UIAlertAction actionWithTitle:@"Để sau" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [weakSelf presentAlertWithTitle:@"Ứng dụng không thể truy cập danh bạ"
                                message:@"Chúng tôi cần truy cập danh bạ của bạn để tìm bạn qua danh bạ"
                                actions:[NSArray arrayWithObjects:okAction, remindLaterAction, nil]];
    }];
}

- (void)performAnimateSelectedContactCollectionView {
    CGFloat selectedContactCollectionViewHeight = 0;
    CGFloat searchBarTopConstValue = 0;
    if (selectedContactCellObjects.count != 0) {
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

- (void)updateSendButtonState {
    if (selectedContactCellObjects.count == 0) {
        [sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
        [sendButton setUserInteractionEnabled:NO];
    } else {
        [sendButton setImage:[UIImage imageNamed:@"Send"] forState:(UIControlStateNormal)];
        [sendButton setUserInteractionEnabled:YES];
    }
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
    NIContactCellObject *contactCellObject;
    NSIndexPath *selectedIndexPath = indexPath;
    
    if (tableView == self.contactTableView) {
        contactCellObject = [contactTableViewModel objectAtIndexPath:indexPath];
    } else if (tableView == self.searchResultTableView) {
        contactCellObject = [searchResultTableViewModel objectAtIndexPath:indexPath];
        selectedIndexPath = [contactTableViewModel indexPathForObject:contactCellObject];
        self.searchBar.text = @"";
        [self.searchResultTableView setHidden:YES];
    } else {
        return;
    }
    
    NISelectedContactCellObject *selectContactObject = [NISelectedContactCellObject
                                                        objectWithPhoneNumber:contactCellObject.phoneNumber
                                                        fullName:contactCellObject.fullNameRemoveDiacritics
                                                        indexPath:selectedIndexPath
                                                        color:contactCellObject.shortNameBackgroundColor];
    if ([selectedContactCellObjects containsObject:selectContactObject]) {
        [selectedContactCellObjects removeObject:selectContactObject];
        contactCellObject.isSelected = NO;
    } else if (selectedContactCellObjects.count < kMaxContactSelect) {
        [selectedContactCellObjects addObject:selectContactObject];
        contactCellObject.isSelected = YES;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSString *message = [NSString stringWithFormat:@"%@ %lu %@", @"Bạn không được chọn quá", (unsigned long)kMaxContactSelect, @"người"];
        [self presentAlertWithTitle:@"Thông báo" message:message actions:nil];
        return;
    }
    
    if (selectedIndexPath) {
        [self.contactTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath]
                                     withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.selectContactCollectionView reloadData];
    [self updateSendButtonState];
    [self performAnimateSelectedContactCollectionView];
    [self.contactInvitationNavigationTitleView updateSubTitleWithNumberSelecContacts:selectedContactCellObjects.count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NISelectedContactCellObject *selectedObject = [collectionViewModel objectAtIndexPath:indexPath];
    [self.contactTableView selectRowAtIndexPath:selectedObject.indexPath
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionNone];
    [self.contactTableView scrollToRowAtIndexPath:selectedObject.indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchResultTableView setHidden:([searchText isEqualToString:@""])];
    if ([searchText isEqualToString:@""]) {
        return;
    }
    
    NSArray *searchContactResults = [listContactCellObject filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (evaluatedObject && [evaluatedObject isKindOfClass:NIContactCellObject.class]) {
            NIContactCellObject *contactCellObject = (NIContactCellObject *)evaluatedObject;
            return ([contactCellObject.fullNameRemoveDiacritics.lowercaseString containsString:[NSString stringRemoveDiacriticsFromString:searchText].lowercaseString]);
        } else {
            return NO;
        }
    }]];
    
    searchResultTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:searchContactResults
                                                                         delegate:(id)[NICellFactory class]];
    self.searchResultTableView.dataSource = searchResultTableViewModel;
    [self.searchResultTableView reloadData];
    [self.emptySearchResultLabel setHidden:(searchContactResults.count != 0)];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

@end
