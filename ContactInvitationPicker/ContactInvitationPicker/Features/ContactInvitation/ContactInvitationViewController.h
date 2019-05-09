//
//  ViewController.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInvitationViewController : UIViewController <UITableViewDelegate, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic) UICollectionView *selectContactCollectionView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UITableView *contactTableView;
@property (nonatomic) UITableView *searchResultTableView;
@property (nonatomic) UILabel *emptySearchResultLabel;

@end

