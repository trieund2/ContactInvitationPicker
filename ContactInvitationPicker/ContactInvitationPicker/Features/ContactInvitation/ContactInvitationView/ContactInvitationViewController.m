//
//  ViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInvitationViewController.h"
#import "ZAContactScanner.h"
#import "NimbusModels.h"
#import "ContactCellObject.h"
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "SelectedContactCellObject.h"
#import "UIColorFromRGB.h"
#import "UIViewController+Alert.h"
#import "NSString+Extension.h"

NSUInteger const kMaxContactSelect = 5;

@interface ContactInvitationViewController ()

@end

@implementation ContactInvitationViewController {
    NSMutableArray<ContactCellObject *> *listContactCellObject;
    NSMutableArray<SelectedContactCellObject *> *selectedContactCellObjects;
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
    [ZAContactBusiness sharedInstance].delegate = self;
    
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
    for (SelectedContactCellObject *object in selectedContactCellObjects) {
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
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.topLayoutGuide
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:4],
                               [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:8],
                               [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeRight)
                                                           multiplier:1
                                                             constant:0],
                               nil]];
    selectContactCollectionViewHeightConst = [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeHeight)
                                                                          relatedBy:(NSLayoutRelationEqual)
                                                                             toItem:nil
                                                                          attribute:(NSLayoutAttributeHeight)
                                                                         multiplier:1
                                                                           constant:0];
    [self.view addConstraint:selectContactCollectionViewHeightConst];
}

- (void)initSearchBar {
    _searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    searchBarTopConst = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                     attribute:(NSLayoutAttributeTop)
                                                     relatedBy:(NSLayoutRelationEqual)
                                                        toItem:self.selectContactCollectionView
                                                     attribute:(NSLayoutAttributeBottom)
                                                    multiplier:1
                                                      constant:0];
    [self.view addConstraint:searchBarTopConst];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.searchBar
                                                            attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchBar
                                                            attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeRight)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchBar
                                                            attribute:(NSLayoutAttributeHeight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:nil
                                                            attribute:(NSLayoutAttributeHeight)
                                                           multiplier:1
                                                             constant:40],
                               nil]];
}

- (void)initContactsTableView {
    _contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contactTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contactTableView];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchBar
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:4],
                               [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeRight)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeBottom)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:0],
                               nil]];
}

- (void)initSearchResultTableView {
    _searchResultTableView = [UITableView new];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchResultTableView setHidden:YES];
    
    self.searchResultTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchResultTableView];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeTop)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeBottom)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.contactTableView
                                                            attribute:(NSLayoutAttributeRight)
                                                           multiplier:1
                                                             constant:0],
                               nil]];
}

- (void)initEmptySearchResultLabel {
    _emptySearchResultLabel = [UILabel new];
    self.emptySearchResultLabel.text = @"Không tìm thấy kết quả phù hợp";
    [self.emptySearchResultLabel setFont:[UIFont systemFontOfSize:15]];
    [self.emptySearchResultLabel setHidden:YES];
    
    self.emptySearchResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchResultTableView addSubview:self.emptySearchResultLabel];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.emptySearchResultLabel
                                                            attribute:(NSLayoutAttributeCenterX)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeCenterX)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.emptySearchResultLabel
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchResultTableView
                                                            attribute:(NSLayoutAttributeTop)
                                                           multiplier:1
                                                             constant:70],
                               nil]];
}

#pragma mark Helper methods

- (void)getAllContacts {
    __weak ContactInvitationViewController *weakSelf = self;
    [[ZAContactBusiness sharedInstance] getContactsWithSortType:(ZAContactSortTypeFamilyName) completionHandler:^{
        if ([[ZAContactBusiness sharedInstance].contactBusinessModels count] == 0) {
            [weakSelf presentAlertWithTitle:@"Không có liên hệ nào trong danh bạ" message:@"Thêm bạn bè vào danh bạ để bắt đầu sử dụng" actions:NULL];
            return;
        }
        
        [self->listContactCellObject removeAllObjects];
        NSArray *results = [[ZAContactBusiness sharedInstance] mapTitleAndContacts];
        for (id object in results) {
            if ([object isKindOfClass:NSString.class]) {
                [self->listContactCellObject addObject:object];
            } else if ([object isKindOfClass:ZAContactBusinessModel.class]) {
                [self->listContactCellObject addObject:[ContactCellObject objectFromContact:(ZAContactBusinessModel *)object]];
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
    ContactCellObject *contactCellObject;
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
    
    SelectedContactCellObject *selectContactObject = [SelectedContactCellObject objectWithContactCellObject:contactCellObject contactIndexPath:selectedIndexPath];
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
    SelectedContactCellObject *selectedContactCellObject = [collectionViewModel objectAtIndexPath:indexPath];
    [self.contactTableView selectRowAtIndexPath:selectedContactCellObject.contactIndexPath
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionNone];
    [self.contactTableView scrollToRowAtIndexPath:selectedContactCellObject.contactIndexPath
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
        if (evaluatedObject && [evaluatedObject isKindOfClass:ContactCellObject.class] && ![evaluatedObject isKindOfClass:NSString.class]) {
            ContactCellObject *contactCellObject = (ContactCellObject *)evaluatedObject;
            return ([contactCellObject.fullNameRemoveDiacritics.lowercaseString containsString:[NSString stringRemoveDiacriticsFromString:searchText].lowercaseString]);
        } else {
            return NO;
        }
    }]];
    
    searchResultTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:searchContactResults delegate:(id)[NICellFactory class]];
    self.searchResultTableView.dataSource = searchResultTableViewModel;
    [self.searchResultTableView reloadData];
    [self.emptySearchResultLabel setHidden:(searchContactResults.count != 0)];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - ZAContactScannerDelegate

- (void)contactDidChange {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Danh bạ của bạn thay đổi"
                                                                             message:@"Bạn có muốn cập nhật danh sách bạn bè?"
                                                                      preferredStyle:(UIAlertControllerStyleAlert)];
    __weak ContactInvitationViewController *weakSelf = self;
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self->selectedContactCellObjects removeAllObjects];
        [weakSelf.selectContactCollectionView reloadData];
        [weakSelf performAnimateSelectedContactCollectionView];
        [[ZAContactBusiness sharedInstance] clearAllContacts];
        [weakSelf getAllContacts];
    }];
    
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"Huỷ" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:NULL];
    }];
    [alertController addAction:okAlertAction];
    [alertController addAction:cancelAlertAction];
    [self presentViewController:alertController animated:YES completion:NULL];
}

@end
