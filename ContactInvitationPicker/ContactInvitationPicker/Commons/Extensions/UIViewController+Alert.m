//
//  UIViewController+Alert.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/8/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <UIKit/UIKit.h>

@implementation UIViewController (Alert)

#pragma mark - Interface methods

- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)presentAlertWithTitle:(NSString *)title message:(NSString * _Nullable)message actions:(NSArray * _Nullable)actions {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (actions == nil || actions.count == 0) {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Đồng ý"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:^{}];
                                                              }];
        [alert addAction:defaultAction];
    } else {
        for (UIAlertAction *action in actions) {
            [alert addAction:action];
        }
    }
    [[self topViewController] presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - Private

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
