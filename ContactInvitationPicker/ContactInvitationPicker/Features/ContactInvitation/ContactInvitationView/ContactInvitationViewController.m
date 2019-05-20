//
//  ViewController.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactInvitationViewController.h"

NSUInteger const kMaxContactSelect = 5;

@interface ContactInvitationViewController ()

@property (nonatomic) NSMutableArray<ContactCellObject *> *listContactCellObjects;
@property (nonatomic) NSMutableArray<SelectedContactCellObject *> *selectedContactCellObjects;
@property (nonatomic) NICollectionViewModel *selectedContactCollectionViewModel;
@property (nonatomic) NSLayoutConstraint *selectContactCollectionViewHeightConst;
@property (nonatomic) NSLayoutConstraint *searchBarTopConst;
@property (nonatomic) UIButton *sendButton;

@end

@implementation ContactInvitationViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    _listContactCellObjects = [NSMutableArray new];
    _selectedContactCellObjects = [NSMutableArray new];
    [[ZAContactAdapter sharedInstance] delegateTo:self];
    
    [self addNavigationBarItems];
    [self initSelectContactCollectionView];
    [self initSearchBar];
    [self initListContactView];
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
    for (SelectedContactCellObject *object in self.selectedContactCellObjects) {
        if (object.phoneNumber != NULL && [object.phoneNumber isKindOfClass:NSString.class]) {
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
    
    _sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.sendButton setUserInteractionEnabled:NO];
    [self.sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
    [self.sendButton addTarget:self action:@selector(touchInSendButton) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sendButton];
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
    _selectedContactCollectionViewModel = [[NICollectionViewModel alloc]
                            initWithListArray:self.selectedContactCellObjects
                            delegate:(id)[NICollectionViewCellFactory class]];
    self.selectContactCollectionView.dataSource = self.selectedContactCollectionViewModel;
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
    self.selectContactCollectionViewHeightConst = [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeHeight)
                                                                               relatedBy:(NSLayoutRelationEqual)
                                                                                  toItem:nil
                                                                               attribute:(NSLayoutAttributeHeight)
                                                                              multiplier:1
                                                                                constant:0];
    [self.view addConstraint:self.selectContactCollectionViewHeightConst];
}

- (void)initSearchBar {
    _searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];
    self.searchBarTopConst = [NSLayoutConstraint constraintWithItem:self.searchBar
                                                          attribute:(NSLayoutAttributeTop)
                                                          relatedBy:(NSLayoutRelationEqual)
                                                             toItem:self.selectContactCollectionView
                                                          attribute:(NSLayoutAttributeBottom)
                                                         multiplier:1
                                                           constant:0];
    [self.view addConstraint:self.searchBarTopConst];
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

- (void)initListContactView {
    _listContactView = [ListContactView new];
    self.listContactView.delegate = self;
    
    self.listContactView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.listContactView];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.listContactView
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchBar
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:4],
                               [NSLayoutConstraint constraintWithItem:self.listContactView
                                                            attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeRight)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.listContactView
                                                            attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.listContactView
                                                            attribute:(NSLayoutAttributeBottom)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.view
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:0],
                               nil]];
}

- (void)initSearchResultTableView {
    _searchResultListContactView = [ListContactView new];
    self.searchResultListContactView.delegate = self;
    [self.searchResultListContactView setHidden:YES];
    
    self.searchResultListContactView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchResultListContactView];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.listContactView
                                                            attribute:(NSLayoutAttributeTop)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeBottom)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.listContactView
                                                            attribute:(NSLayoutAttributeBottom)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeLeft)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.listContactView
                                                            attribute:(NSLayoutAttributeLeft)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeRight)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.listContactView
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
    [self.searchResultListContactView addSubview:self.emptySearchResultLabel];
    [self.view addConstraints:[NSArray arrayWithObjects:
                               [NSLayoutConstraint constraintWithItem:self.emptySearchResultLabel
                                                            attribute:(NSLayoutAttributeCenterX)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeCenterX)
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:self.emptySearchResultLabel
                                                            attribute:(NSLayoutAttributeTop)
                                                            relatedBy:(NSLayoutRelationEqual)
                                                               toItem:self.searchResultListContactView
                                                            attribute:(NSLayoutAttributeTop)
                                                           multiplier:1
                                                             constant:70],
                               nil]];
}

#pragma mark Helper methods

- (void)getAllContacts {
    __weak ContactInvitationViewController *weakSelf = self;
    [[ZAContactAdapter sharedInstance] getOrderContactsWithSortType:(ZAContactSortTypeFamilyName) completionHandler:^(NSArray * _Nonnull contacts) {
        if (contacts.count == 0) {
            [weakSelf presentAlertWithTitle:@"Không có liên hệ nào trong danh bạ" message:@"Thêm bạn bè vào danh bạ để bắt đầu sử dụng" actions:NULL];
            return;
        }
        
        [self.listContactCellObjects removeAllObjects];
        for (id object in contacts) {
            if ([object isKindOfClass:NSString.class]) {
                [weakSelf.listContactCellObjects addObject:object];
            } else if ([object isKindOfClass:ZAContactAdapterModel.class]) {
                [weakSelf.listContactCellObjects addObject:[ContactCellObject objectFromContact:(ZAContactAdapterModel *)object]];
            }
        }
        [weakSelf.listContactView setDataSourceWithSectionedArray:weakSelf.listContactCellObjects];
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
    if (self.selectedContactCellObjects.count != 0) {
        selectedContactCollectionViewHeight = 40;
        searchBarTopConstValue = 4;
    }
    if (self.selectContactCollectionViewHeightConst.constant == selectedContactCollectionViewHeight) { return; }
    self.selectContactCollectionViewHeightConst.constant = selectedContactCollectionViewHeight;
    self.searchBarTopConst.constant = searchBarTopConstValue;
    
    __weak ContactInvitationViewController *weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)updateSendButtonState {
    if (self.selectedContactCellObjects.count == 0) {
        [self.sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
        [self.sendButton setUserInteractionEnabled:NO];
    } else {
        [self.sendButton setImage:[UIImage imageNamed:@"Send"] forState:(UIControlStateNormal)];
        [self.sendButton setUserInteractionEnabled:YES];
    }
}

#pragma mark - ListContactViewDelegate

- (void)listContactView:(ListContactView *)listContactView didSelectRowAtIndexpath:(NSIndexPath *)indexPath {
    ContactCellObject *contactCellObject;
    NSIndexPath *contactIndexPath = indexPath;
    
    id object = [listContactView objectForIndexPath:indexPath];
    if ([object isKindOfClass:ContactCellObject.class]) {
        contactCellObject = (ContactCellObject *)object;
    } else {
        return;
    }
    
    if (listContactView == self.searchResultListContactView) {
        NSIndexPath *_indexPath = [self.listContactView indexPathForObject:contactCellObject];
        if (_indexPath) {
            contactIndexPath = _indexPath;
        } else {
            return;
        }
        self.searchBar.text = @"";
        [self.searchResultListContactView setHidden:YES];
    }
    
    SelectedContactCellObject *selectContactObject = [SelectedContactCellObject objectWithContactCellObject:contactCellObject contactIndexPath:contactIndexPath];
    if ([self.selectedContactCellObjects containsObject:selectContactObject]) {
        [self.selectedContactCellObjects removeObject:selectContactObject];
        contactCellObject.isSelected = NO;
    } else if (self.selectedContactCellObjects.count < kMaxContactSelect) {
        [self.selectedContactCellObjects addObject:selectContactObject];
        contactCellObject.isSelected = YES;
    } else {
        [listContactView deSelectRowAtIndexPath:indexPath animated:YES];
        NSString *message = [NSString stringWithFormat:@"%@ %lu %@", @"Bạn không được chọn quá", (unsigned long)kMaxContactSelect, @"người"];
        [self presentAlertWithTitle:@"Thông báo" message:message actions:nil];
        return;
    }
    
    [self.listContactView reloadRowAtIndexPaths:[NSArray arrayWithObject:contactIndexPath]];
    [self.selectContactCollectionView reloadData];
    [self updateSendButtonState];
    [self performAnimateSelectedContactCollectionView];
    [self.contactInvitationNavigationTitleView updateSubTitleWithNumberSelecContacts:self.selectedContactCellObjects.count];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedContactCellObject *selectedContactCellObject = [self.selectedContactCollectionViewModel objectAtIndexPath:indexPath];
    [self.listContactView selectRowAtIndexPath:selectedContactCellObject.contactIndexPath animated:YES];
    [self.listContactView scrollToItemAtIndexPath:selectedContactCellObject.contactIndexPath];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchResultListContactView setHidden:([searchText isEqualToString:@""])];
    if ([searchText isEqualToString:@""]) {
        return;
    }
    
    NSArray *searchContactResults = [self.listContactCellObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (evaluatedObject && [evaluatedObject isKindOfClass:ContactCellObject.class] && ![evaluatedObject isKindOfClass:NSString.class]) {
            ContactCellObject *contactCellObject = (ContactCellObject *)evaluatedObject;
            return ([contactCellObject.fullNameRemoveDiacritics.lowercaseString containsString:[NSString stringRemoveDiacriticsFromString:searchText].lowercaseString]);
        } else {
            return NO;
        }
    }]];
    
    [self.searchResultListContactView setDataSourceWithListArray:searchContactResults];
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
        [weakSelf.selectedContactCellObjects removeAllObjects];
        [weakSelf.selectContactCollectionView reloadData];
        [weakSelf performAnimateSelectedContactCollectionView];
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
