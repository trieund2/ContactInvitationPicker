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
#import "SelectedContactCellObject.h"
#import "UIColorFromRGB.h"
#import "UIViewController+Alert.h"
#import "NSString+Extension.h"
#import "ListContactView.h"
#import "ListSelectedContactView.h"

extern NSUInteger const kMaxContactSelect;

@class ContactInvitationViewController;

@protocol ContactInvitationViewControllerDelegate <NSObject>

@required
- (void)didSelectSendContacts:(NSArray<SelectedContactCellObject*> *)contacts;

@end

@interface ContactInvitationViewController : UIViewController <UISearchBarDelegate, ZAContactScannerDelegate, ListContactViewDelegate, ListSelectedContactViewDelegate>

@property (nonatomic, weak) id<ContactInvitationViewControllerDelegate> delegate;
@property (nonatomic, readonly) ContactInviNavigationTitleView *contactInvitationNavigationTitleView;
@property (nonatomic, readonly) ListSelectedContactView *selectedContactView;
@property (nonatomic, readonly) UISearchBar *searchBar;
@property (nonatomic, readonly) ListContactView *listContactView;
@property (nonatomic, readonly) ListContactView *searchResultListContactView;
@property (nonatomic, readonly) UILabel *emptySearchResultLabel;

@end

