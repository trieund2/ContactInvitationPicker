//
//  ContactInviNavigationTitleView.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactInviNavigationTitleView : UIView

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *subTitleLabel;

- (void)updateSubTitleWithNumberSelectContacts:(NSUInteger)number;

@end

NS_ASSUME_NONNULL_END
