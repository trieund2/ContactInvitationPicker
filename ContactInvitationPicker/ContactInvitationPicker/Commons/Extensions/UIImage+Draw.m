//
//  UIImage+Draw.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/13/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "UIImage+Draw.h"

@implementation UIImage (Draw)

+ (UIImage *)drawText:(NSString *)text inImage:(UIImage *)image atPoint:(CGPoint)point {
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIGraphicsBeginImageContext(CGSizeMake(30, 30));
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, 30, 30);
    [[UIColor whiteColor] set];
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
