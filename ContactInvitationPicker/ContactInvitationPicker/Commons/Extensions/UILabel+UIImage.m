//
//  UILabel+UIImage.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/13/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "UILabel+UIImage.h"
#include <QuartzCore/QuartzCore.h>

@implementation UILabel (UIImage)

+ (UIImage*)imageWithFont:(UIFont*)font text:(NSString*)text colour:(UIColor*)colour
{
    // For retina display - double the size
    font = [UIFont fontWithName:font.familyName size:font.pointSize * 2.0f];
    CGFloat size = font.pointSize;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = font;
    label.text = text;
    label.textColor = colour;
    label.backgroundColor = [UIColor clearColor];
    
    // For retina display - 2x scaling factor
    return [UIImage imageWithCGImage:[label image].CGImage scale:2.0 orientation:UIImageOrientationUp];
}

/*
 http://stackoverflow.com/a/11867557
 */
- (UIImage*)image
{
    NSString* fileName = [self imageFileName];
    UIImage* image = [UILabel loadImage:fileName];
    if (image != nil)
        return image;
    
    // Create a "canvas" (image context) to draw in.
    UIGraphicsBeginImageContext([self bounds].size);
    
    // Make the CALayer to draw in our "canvas".
    [[self layer] renderInContext: UIGraphicsGetCurrentContext()];
    
    // Fetch an UIImage of our "canvas".
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();
    
    [UILabel saveImage:image withName:fileName];
    
    // Return the image.
    return image;
}

- (NSString*)imageFileName
{
    NSString* fontName = self.font.familyName;
    NSString* text = self.text;
    NSString *colourString = [[CIColor colorWithCGColor:[[self textColor] CGColor]] stringRepresentation];
    NSString* size = [@(self.font.pointSize) stringValue];
    
    NSCharacterSet* uppercaseLetterCharacterSet = [NSCharacterSet uppercaseLetterCharacterSet];
    if ([uppercaseLetterCharacterSet characterIsMember:[text characterAtIndex:0]])
    {
        text = [NSString stringWithFormat:@"%@+", text];
    }
    
    return [NSString stringWithFormat:@"%@_%@_%@_%@.png", fontName, colourString, size, text];
}

+ (void)saveImage:(UIImage *)image withName:(NSString *)name
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}

+ (UIImage*)loadImage:(NSString*)name
{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:fullPath];
}

@end
