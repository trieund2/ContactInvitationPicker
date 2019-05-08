//
//  ViewController.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactInvitationViewController : UIViewController <UITableViewDelegate>

@property (nonatomic) UICollectionView *selectContactCollectionView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UITableView *contactTableView;

@end

