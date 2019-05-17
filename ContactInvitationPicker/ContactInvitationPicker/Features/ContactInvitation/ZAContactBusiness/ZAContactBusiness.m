//
//  ZAContactBusiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusiness.h"

@implementation ZAContactBusiness

+ (instancetype)sharedInstance {
    static ZAContactBusiness *zaContactBusiness;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        zaContactBusiness = [ZAContactBusiness new];
    });
    return zaContactBusiness;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactBusinessModels = [NSMutableArray new];
        _contactScanner = [ZAContactScanner new];
    }
    return self;
}

- (void)setDelegate:(id<ZAContactScannerDelegate>)delegate {
    _delegate = delegate;
    self.contactScanner.delegate = self.delegate;
}

- (void)getContactsWithSortType:(ZAContactSortType)sortType
                          completionHandler:(void (^)(void))completionHandler
                               errorHandler:(void (^)(ZAContactError error))errorHandler {
    if (self.contactBusinessModels.count > 0) {
        completionHandler();
        return;
    }
    
    __weak ZAContactBusiness *weakSelf = self;
    
    [self.contactScanner requestAccessContactWithAccessGranted:^{
        dispatch_queue_t queue = dispatch_queue_create("getContacts", nil);
        dispatch_async(queue, ^{
            [weakSelf.contactScanner getContactsWithSortType:sortType completionHandler:^(NSArray<ZAContact *> * _Nonnull contacts) {
                for (ZAContact* contact in contacts) {
                    ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
                    if (contactBusinessModel != nil) {
                        [weakSelf.contactBusinessModels addObject:contactBusinessModel];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler();
                });
            } errorHandler:^(ZAContactError error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(error);
                });
            }];
        });
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

- (NSArray *)mapTitleAndContacts {
    NSMutableArray *titleAndContacts = [NSMutableArray new];
    NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
    NSString *previousTitle;
    NSString *allAlphabets = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (ZAContactBusinessModel *zaContactBusinessModel in self.contactBusinessModels) {
        if ([zaContactBusinessModel.fullNameRemoveDiacritics length] > 0) {
            NSString *currentTitle = [[zaContactBusinessModel.fullNameRemoveDiacritics substringToIndex:1] uppercaseString];
            bool isAlphabet = [allAlphabets containsString:currentTitle];
            if (![currentTitle isEqualToString:previousTitle] && isAlphabet) {
                [titleAndContacts addObject:currentTitle];
                previousTitle = currentTitle;
            }
            if (isAlphabet) {
                [titleAndContacts addObject:zaContactBusinessModel];
            } else {
                [nonAlphabetContacts addObject:zaContactBusinessModel];
            }
        }
    }
    if ([nonAlphabetContacts count] > 0) {
        [nonAlphabetContacts insertObject:@"#" atIndex:0];
        [nonAlphabetContacts addObjectsFromArray:titleAndContacts];
        return nonAlphabetContacts;
    } else {
        return titleAndContacts;
    }
}

- (void)clearAllContacts {
    [self.contactBusinessModels removeAllObjects];
}

@end
