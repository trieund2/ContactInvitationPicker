//
//  ListSelectedContactView.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/21/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICollectionViewModel.h"
#import "NICollectionViewCellFactory.h"
#import "SelectedContactCellObject.h"
#import "Masonry.h"

@class ListSelectedContactView;

@protocol ListSelectedContactViewDelegate <NSObject>

@required
- (void)listSelectedContactView:(ListSelectedContactView *)listSelectedContactView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ListSelectedContactView : UIView <UICollectionViewDelegate>

@property (nonatomic, weak) id<ListSelectedContactViewDelegate> delegate;
@property (nonatomic, readonly) UICollectionView *selectContactCollectionView;

- (void)reloadData;
- (void)setDataSourceWithCellObjects:(NSArray<SelectedContactCellObject *> *)cellObjects;
- (id)objectForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
