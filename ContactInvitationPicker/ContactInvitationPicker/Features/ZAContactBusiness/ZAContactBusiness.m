//
//  ZAContactBusiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusiness.h"

@implementation ZAContactBusiness

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactBusinessModels = [NSMutableArray new];
    }
    return self;
}

- (void)requestAccessContactWithCompletionHandler:(void (^)(BOOL))completionHandler errorHandler:(void (^)(NSError * _Nonnull))errorHandler {
    [ZAContactScaner requestAccessContactWithCompletionHandler:^(BOOL granted) {
        completionHandler(granted);
    } errorHandler:^(NSError * _Nonnull error) {
        errorHandler(error);
    }];
}

- (void)getAllContactsFromLocalWithCompletionHalder:(void (^)(void))completionHalder
                                                  errorHandler:(void (^)(NSError * _Nonnull))errorHandler {
    __weak ZAContactBusiness *weakSelf = self;
    
    [ZAContactScaner getAllContactsWithCompletionHandler:^(NSArray<ZAContact *> * _Nonnull contacts) {
        for (ZAContact* contact in contacts) {
            ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
            if (contactBusinessModel != nil) {
                [weakSelf.contactBusinessModels addObject:contactBusinessModel];
            }
        }
        completionHalder();
    } errorHandler:^(NSError * _Nonnull error) {
        errorHandler(error);
    }];
}

- (NSArray *)mapContactAndTitles {
    NSMutableArray *resultArray = [NSMutableArray new];
    NSString *previousTitle;
    for (ZAContactBusinessModel *zaContactBusinessModel in self.contactBusinessModels) {
        if ([zaContactBusinessModel.fullNameIgnoreUnicode length] > 0) {
            NSString *currentTitle = [zaContactBusinessModel.fullNameIgnoreUnicode substringToIndex:1];
            if (currentTitle != previousTitle) {
                [resultArray addObject:currentTitle];
                previousTitle = currentTitle;
            }
            [resultArray addObject:zaContactBusinessModel];
        }
    }
    return resultArray;
}

- (NSArray *)searchContactWithSearchText:(NSString *)searchText {
    NSArray *contactSearchReultArray = [self.contactBusinessModels filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        if (object != NULL && [object isKindOfClass:[ZAContactBusinessModel class]]) {
            ZAContactBusinessModel *contactBussinessModel = (ZAContactBusinessModel *)object;
            return [contactBussinessModel.fullNameIgnoreUnicode.lowercaseString containsString:[NSString stringIgnoreUnicodeFromString:searchText].lowercaseString];
        } else {
            return NO;
        }
    }]];
    return contactSearchReultArray;
}

@end
