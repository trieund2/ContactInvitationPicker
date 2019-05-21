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
    _selectContactCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.selectContactCollectionView.backgroundColor = UIColor.clearColor;
    self.selectContactCollectionView.delegate = self;
    
    self.selectContactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.selectContactCollectionView];
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeTop)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeTop)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeLeft)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeRight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.selectContactCollectionView attribute:(NSLayoutAttributeHeight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeHeight)
                                                      multiplier:1
                                                        constant:0],
                          nil]];
}

#pragma mark - Interface methods

- (void)reloadData {
    [self.selectContactCollectionView reloadData];
}

- (void)setDataSourceWithCellObjects:(NSArray<SelectedContactCellObject *> *)cellObjects {
    _selectedContactCollectionViewModel = [[NICollectionViewModel alloc]
                                           initWithListArray:cellObjects
                                           delegate:(id)[NICollectionViewCellFactory class]];
    self.selectContactCollectionView.dataSource = self.selectedContactCollectionViewModel;
    [self.selectContactCollectionView reloadData];
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
