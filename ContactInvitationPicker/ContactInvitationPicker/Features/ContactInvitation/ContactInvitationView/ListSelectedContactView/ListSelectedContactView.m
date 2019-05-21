//
//  ListSelectedContactView.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/21/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ListSelectedContactView.h"

@interface ListSelectedContactView ()

@property (nonatomic) NICollectionViewModel *selectedContactCollectionViewModel;

@end

@implementation ListSelectedContactView


#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSelectedContactCollectionView];
    }
    return self;
}

- (void)initSelectedContactCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(40, 40);
    layout.minimumInteritemSpacing = 4;
    _selectedContactsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.selectedContactsCollectionView.backgroundColor = UIColor.clearColor;
    self.selectedContactsCollectionView.delegate = self;
    [self addSubview:self.selectedContactsCollectionView];
    [self.selectedContactsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

#pragma mark - Interface methods

- (void)reloadData {
    [self.selectedContactsCollectionView reloadData];
}

- (void)setDataSourceWithCellObjects:(NSArray<SelectedContactCellObject *> *)cellObjects {
    _selectedContactCollectionViewModel = [[NICollectionViewModel alloc]
                                           initWithListArray:cellObjects
                                           delegate:(id)[NICollectionViewCellFactory class]];
    self.selectedContactsCollectionView.dataSource = self.selectedContactCollectionViewModel;
    [self.selectedContactsCollectionView reloadData];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    return [self.selectedContactCollectionViewModel objectAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ListSelectedContactViewDelegate)]) {
        [self.delegate listSelectedContactView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
