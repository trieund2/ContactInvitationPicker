//
//  ListContactView.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/18/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ListContactView.h"

@interface ListContactView ()

@property (nonatomic) NITableViewModel *contactTableViewModel;

@end

@implementation ListContactView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContactsTableView];
    }
    return self;
}

- (void)initContactsTableView {
    _contactTableView = [UITableView new];
    self.contactTableView.delegate = self;
    self.contactTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contactTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contactTableView];
    [self addConstraints:[NSArray arrayWithObjects:
                          [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                       attribute:(NSLayoutAttributeTop)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeTop)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                       attribute:(NSLayoutAttributeRight)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeRight)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                       attribute:(NSLayoutAttributeLeft)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeLeft)
                                                      multiplier:1
                                                        constant:0],
                          [NSLayoutConstraint constraintWithItem:self.contactTableView
                                                       attribute:(NSLayoutAttributeBottom)
                                                       relatedBy:(NSLayoutRelationEqual)
                                                          toItem:self
                                                       attribute:(NSLayoutAttributeBottom)
                                                      multiplier:1
                                                        constant:0],
                          nil]];
}

#pragma mark - Interface methods

- (void)setDataSourceWithSectionedArray:(NSArray *)sectionedArray {
    _contactTableViewModel = [[NITableViewModel alloc] initWithSectionedArray:sectionedArray delegate:(id)[NICellFactory class]];
    self.contactTableView.dataSource = self.contactTableViewModel;
    [self.contactTableViewModel setSectionIndexType:(NITableViewModelSectionIndexDynamic) showsSearch:YES showsSummary:YES];
    [self reloadData];
}

- (void)setDataSourceWithListArray:(NSArray *)listArray {
    _contactTableViewModel = [[NITableViewModel alloc] initWithListArray:listArray delegate:(id)[NICellFactory class]];
    self.contactTableView.dataSource = self.contactTableViewModel;
    [self reloadData];
}

- (void)reloadData {
    [self.contactTableView reloadData];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.contactTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:(UITableViewScrollPositionNone)];
}

- (void)deSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.contactTableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.contactTableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:UITableViewScrollPositionTop
                                         animated:YES];
}

- (void)reloadRowAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.contactTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationNone)];
}

- (id)objectForIndexPath:(NSIndexPath *)indexPath {
    return [self.contactTableViewModel objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.contactTableViewModel indexPathForObject:object];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    view.backgroundColor = UIColor.whiteColor;
    NSString *title = [self.contactTableViewModel tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [UILabel new];
    label.text = title;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.textColor = UIColorFromRGB(0x79848F);
    label.frame = CGRectMake(6, 0, 100, 30);
    [view addSubview:label];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate listContactView:self didSelectRowAtIndexpath:indexPath];
    }
}

@end
