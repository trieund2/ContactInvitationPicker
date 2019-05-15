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

- (void)getAllContactsFromLocalWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(void (^)(ZAContactError error))errorHandler {
    
    __weak ZAContactBusiness *weakSelf = self;
    
    [ZAContactScaner requestAccessContactWithAccessGranted:^{
        [ZAContactScaner getAllContactsWithSortType:sortType CompletionHandler:^(NSArray<ZAContact *> * _Nonnull contacts) {
            for (ZAContact* contact in contacts) {
                ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
                if (contactBusinessModel != nil) {
                    [weakSelf.contactBusinessModels addObject:contactBusinessModel];
                }
            }
            completionHandler();
        } errorHandler:^(ZAContactError error) {
            errorHandler(error);
        }];
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

- (NSArray *)mapTitleAndContacts {
    NSMutableArray *titleAndContacts = [NSMutableArray new];
    NSString *previousTitle;
    for (ZAContactBusinessModel *zaContactBusinessModel in self.contactBusinessModels) {
        if ([zaContactBusinessModel.fullNameRemoveDiacritics length] > 0) {
            NSString *currentTitle = [zaContactBusinessModel.fullNameRemoveDiacritics substringToIndex:1];
            if (currentTitle != previousTitle) {
                [titleAndContacts addObject:currentTitle];
                previousTitle = currentTitle;
            }
            [titleAndContacts addObject:zaContactBusinessModel];
        }
    }
    return titleAndContacts;
}

@end
