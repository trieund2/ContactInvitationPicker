//
//  ListSelectContactView.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/21/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "SelectedContactCellObject.h"

@class ListSelectContactView;

@protocol ListSelectContactViewDelegate <NSObject>

@required
- (void)listSelectContactView:(ListSelectContactView *)listSelectContactView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ListSelectContactView : UIView <UICollectionViewDelegate>

@property (nonatomic, weak) id<ListSelectContactViewDelegate> delegate;
@property (nonatomic, readonly) UICollectionView *selectContactCollectionView;

- (void)reloadData;
- (void)setDataSourceWithCellObjects:(NSArray<SelectedContactCellObject *> *)cellObjects;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
