//
//  RootViewController.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/10/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColorFromRGB.h"
#import "ContactInvitationViewController.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootViewController : UIViewController <MFMessageComposeViewControllerDelegate, ContactInvitationViewControllerDelegate>

@property (nonatomic, readonly) UIButton *contactInvitationPickerButton;

@end

NS_ASSUME_NONNULL_END
