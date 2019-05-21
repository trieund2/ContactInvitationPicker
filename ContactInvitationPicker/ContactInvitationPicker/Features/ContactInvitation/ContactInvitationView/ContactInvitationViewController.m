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
@property (nonatomic) UIButton *sendButton;

@end

@implementation ContactInvitationViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE9E9E9);
    _listContactCellObjects = [NSMutableArray new];
    _selectedContactCellObjects = [NSMutableArray new];
    [[ZAContactAdapter sharedInstance] addDelegate:self];
    
    [self addNavigationBarItems];
    [self initSelectedContactView];
    [self initSearchBar];
    [self initListContactView];
    [self initSearchResultTableView];
    [self initEmptySearchResultLabel];
    [self getAllContacts];
}

- (void)dealloc {
    [[ZAContactAdapter sharedInstance] removeDelegate:self];
}

#pragma mark - Handle UI actions

- (void)touchInCancelButton {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchInSendButton {
    if ([self.delegate conformsToProtocol:@protocol(ContactInvitationViewControllerDelegate)]) {
        __weak ContactInvitationViewController *weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            [weakSelf.delegate didSelectSendContacts:weakSelf.selectedContactCellObjects];
        }];
    }
}

#pragma mark - Init layouts

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

- (void)initSelectedContactView {
    _selectedContactView = [ListSelectedContactView new];
    self.selectedContactView.backgroundColor = UIColor.clearColor;
    self.selectedContactView.delegate = self;
    [self.view addSubview:self.selectedContactView];
    
    [self.selectedContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(4);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
}

- (void)initSearchBar {
    _searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Nhập tên bạn bè";
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.selectedContactView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

- (void)initListContactView {
    _listContactView = [ListContactView new];
    self.listContactView.delegate = self;
    [self.view addSubview:self.listContactView];
    [self.listContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(4);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)initSearchResultTableView {
    _searchResultListContactView = [ListContactView new];
    self.searchResultListContactView.delegate = self;
    [self.searchResultListContactView setHidden:YES];
    [self.view addSubview:self.searchResultListContactView];
    [self.searchResultListContactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.listContactView);
    }];
}

- (void)initEmptySearchResultLabel {
    _emptySearchResultLabel = [UILabel new];
    self.emptySearchResultLabel.text = @"Không tìm thấy kết quả phù hợp";
    [self.emptySearchResultLabel setFont:[UIFont systemFontOfSize:15]];
    [self.emptySearchResultLabel setHidden:YES];
    [self.searchResultListContactView addSubview:self.emptySearchResultLabel];
    [self.emptySearchResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.searchResultListContactView).offset(70);
    }];
}

#pragma mark - Helper methods

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
        UIAlertAction *remindLaterAction = [UIAlertAction actionWithTitle:@"Để sau" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
        [weakSelf presentAlertWithTitle:@"Ứng dụng không thể truy cập danh bạ"
                                message:@"Chúng tôi cần truy cập danh bạ của bạn để tìm bạn qua danh bạ"
                                actions:[NSArray arrayWithObjects:okAction, remindLaterAction, nil]];
    }];
}

- (void)performAnimateSelectedContactCollectionView {
    BOOL needUpdateConstraint = NO;
    if (self.selectedContactCellObjects.count > 0 && self.selectedContactView.frame.size.height == 0) {
        needUpdateConstraint = YES;
        [self.selectedContactView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedContactView.mas_bottom).offset(4);
        }];
    } else if (self.selectedContactCellObjects.count == 0 && self.selectedContactView.frame.size.height == 40) {
        needUpdateConstraint = YES;
        [self.selectedContactView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedContactView.mas_bottom);
        }];
    }
    if (!needUpdateConstraint) { return; }
    ContactInvitationViewController * __weak weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {}];
}

- (void)updateSendButtonState {
    if (self.selectedContactCellObjects.count > 0) {
        [self.sendButton setImage:[UIImage imageNamed:@"Send"] forState:(UIControlStateNormal)];
        [self.sendButton setUserInteractionEnabled:YES];
    } else {
        [self.sendButton setImage:[UIImage imageNamed:@"SendDisable"] forState:(UIControlStateNormal)];
        [self.sendButton setUserInteractionEnabled:NO];
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
            self.searchBar.text = @"";
            [self.searchResultListContactView setHidden:YES];
        } else {
            return;
        }
    }
    
    SelectedContactCellObject *selectedContactObject = [SelectedContactCellObject objectWithContactCellObject:contactCellObject contactIndexPath:contactIndexPath];
    if ([self.selectedContactCellObjects containsObject:selectedContactObject]) {
        [self.selectedContactCellObjects removeObject:selectedContactObject];
        contactCellObject.isSelected = NO;
    } else if (self.selectedContactCellObjects.count < kMaxContactSelect) {
        [self.selectedContactCellObjects addObject:selectedContactObject];
        contactCellObject.isSelected = YES;
    } else {
        [listContactView deSelectRowAtIndexPath:indexPath animated:YES];
        NSString *message = [NSString stringWithFormat:@"%@ %lu %@", @"Bạn không được chọn quá", (unsigned long)kMaxContactSelect, @"người"];
        [self presentAlertWithTitle:@"Thông báo" message:message actions:nil];
        return;
    }
    
    [self.listContactView reloadRowAtIndexPaths:[NSArray arrayWithObject:contactIndexPath]];
    [self.selectedContactView setDataSourceWithCellObjects:self.selectedContactCellObjects];
    [self updateSendButtonState];
    [self performAnimateSelectedContactCollectionView];
    [self.contactInvitationNavigationTitleView updateSubTitleWithNumberSelectContacts:self.selectedContactCellObjects.count];
}

#pragma mark - ListSelectContactViewDelegate

- (void)listSelectedContactView:(ListSelectedContactView *)listSelectedContactView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.selectedContactView objectForIndexPath:indexPath];
    if (object && [object isKindOfClass:SelectedContactCellObject.class]) {
        SelectedContactCellObject *selectedContactCellObject = (SelectedContactCellObject *)object;
        [self.listContactView selectRowAtIndexPath:selectedContactCellObject.contactIndexPath animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchResultListContactView setHidden:([searchText isEqualToString:@""])];
    if ([searchText isEqualToString:@""]) { return; }
    NSArray *searchContactResults = [self.listContactCellObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (evaluatedObject && [evaluatedObject isKindOfClass:ContactCellObject.class]) {
            ContactCellObject *contactCellObject = (ContactCellObject *)evaluatedObject;
            return ([contactCellObject.fullNameRemoveDiacritics.lowercaseString containsString:[NSString stringRemoveDiacriticsFromString:searchText].lowercaseString]);
        } else {
            return NO;
        }
    }]];
    [self.searchResultListContactView setDataSourceWithListArray:searchContactResults];
    [self.emptySearchResultLabel setHidden:(searchContactResults.count != 0)];
}

#pragma mark - ZAContactScannerDelegate

- (void)contactDidChange {
    __weak ContactInvitationViewController *weakSelf = self;
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"Đồng ý" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.selectedContactCellObjects removeAllObjects];
        [weakSelf.selectedContactView reloadData];
        [weakSelf updateSendButtonState];
        [weakSelf performAnimateSelectedContactCollectionView];
        [weakSelf getAllContacts];
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"Huỷ" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
    [self presentAlertWithTitle:@"Danh bạ của bạn thay đổi"
                        message:@"Bạn có muốn cập nhật danh sách bạn bè?"
                        actions:[NSArray arrayWithObjects:okAlertAction, cancelAlertAction, nil]];
}

@end
