//
//  UIImageView+Letters.h
//  ContactInvitationPicker
//
//  Created by MACOS on 5/14/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const kFontResizingProportion;

@interface UIImageView (Letters)

- (void)setImageWithString:(NSString *)string
                     color:(UIColor *)color
                  circular:(BOOL)isCircular
            textAttributes:(NSDictionary *)textAttributes
                      size: (CGSize)size;

@end

NS_ASSUME_NONNULL_END
