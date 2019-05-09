//
//  NSString+Extension.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/9/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)ignoreUnicode:(NSString *)text {
    NSString *result = [text stringByFoldingWithOptions:(NSDiacriticInsensitiveSearch) locale:NSLocale.currentLocale];
    result = [result stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    result = [result stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    return result;
}

@end
