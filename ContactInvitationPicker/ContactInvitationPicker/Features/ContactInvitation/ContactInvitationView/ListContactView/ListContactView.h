//
//  ListContactView.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/18/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"
#import "UIColorFromRGB.h"
#import "Masonry.h"

@class ListContactView;

@protocol ListContactViewDelegate <NSObject>

@required
- (void)listContactView:(ListContactView *)listContactView didSelectRowAtIndexpath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ListContactView : UIView <UITableViewDelegate>

@property (nonatomic, weak) id<ListContactViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *contactTableView;

// Set datasource
- (void)setDataSourceWithListArray:(NSArray *)listArray;
- (void)setDataSourceWithSectionedArray:(NSArray *)sectionedArray;
- (void)reloadData;

// Selection
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)deSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

// Get cell object
- (id)objectForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@end

NS_ASSUME_NONNULL_END
