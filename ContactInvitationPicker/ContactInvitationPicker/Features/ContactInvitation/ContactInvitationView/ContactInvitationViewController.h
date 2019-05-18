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
#import "ZAContactAdapter.h"
#import "NimbusModels.h"
#import "ContactCellObject.h"
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "SelectedContactCellObject.h"
#import "UIColorFromRGB.h"
#import "UIViewController+Alert.h"
#import "NSString+Extension.h"
#import "ListContactView.h"

extern NSUInteger const kMaxContactSelect;

@interface ContactInvitationViewController : UIViewController <UITableViewDelegate, UICollectionViewDelegate, UISearchBarDelegate, MFMessageComposeViewControllerDelegate, ZAContactScannerDelegate, ListContactViewDelegate>

@property (nonatomic, readonly) ContactInviNavigationTitleView *contactInvitationNavigationTitleView;
@property (nonatomic, readonly) UICollectionView *selectContactCollectionView;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) ListContactView *listContactView;
@property (nonatomic, readonly) ListContactView *searchResultListContactView;
@property (nonatomic, readonly) UILabel *emptySearchResultLabel;

@end

