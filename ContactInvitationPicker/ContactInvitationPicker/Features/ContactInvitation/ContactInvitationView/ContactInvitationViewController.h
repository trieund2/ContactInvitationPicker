//
//  ViewController.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ContactInviNavigationTitleView.h"
#import "ZAContactBusiness.h"

extern NSUInteger const kMaxContactSelect;

@interface ContactInvitationViewController : UIViewController <UITableViewDelegate, UICollectionViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, readonly) ZAContactBusiness *contactBusiness;
@property (nonatomic, readonly) ContactInviNavigationTitleView *contactInvitationNavigationTitleView;
@property (nonatomic, readonly) UICollectionView *selectContactCollectionView;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) UITableView *contactTableView;
@property (nonatomic, readonly) UITableView *searchResultTableView;
@property (nonatomic, readonly) UILabel *emptySearchResultLabel;

@end

