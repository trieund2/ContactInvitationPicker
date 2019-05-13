//
//  UIImage+Draw.h
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/13/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Draw)

+ (UIImage*)drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point;

@end

NS_ASSUME_NONNULL_END
