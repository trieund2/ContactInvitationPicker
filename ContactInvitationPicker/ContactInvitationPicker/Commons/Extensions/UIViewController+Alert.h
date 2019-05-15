//
//  UIViewController+Alert.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

- (void)presentAlertWithTitle:(NSString *)title
                      message:(NSString * _Nullable)message
                      actions:(NSArray * _Nullable)actions;

@end

NS_ASSUME_NONNULL_END
