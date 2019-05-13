//
//  ZAContactBussiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBussiness.h"

@implementation ZAContactBussiness

- (void)requestAccessContactWithCompletionHandler:(void (^)(BOOL))completionHandler errorHandler:(void (^)(NSError * _Nonnull))errorHandler {
    [ZAContactScaner requestAccessContactWithCompletionHandler:^(BOOL granted) {
        completionHandler(granted);
    } errorHandler:^(NSError * _Nonnull error) {
        errorHandler(error);
    }];
}

- (void)getAllContactsFromLocal {
    
}

@end
