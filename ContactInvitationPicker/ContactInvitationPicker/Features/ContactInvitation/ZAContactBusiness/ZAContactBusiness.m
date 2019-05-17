//
//  ZAContactBusiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusiness.h"

@implementation ZAContactBusiness {
    NSMutableArray *contactBusinessModels;
}

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
        contactBusinessModels = [NSMutableArray new];
        _contactScanner = [ZAContactScanner new];
    }
    return self;
}

- (void)setDelegate:(id<ZAContactScannerDelegate>)delegate {
    _delegate = delegate;
    self.contactScanner.delegate = self.delegate;
}

- (void)getContactsWithSortType:(ZAContactSortType)sortType
              completionHandler:(void (^)(NSArray<ZAContactBusinessModel *> * _Nonnull))completionHandler
                   errorHandler:(void (^)(ZAContactError))errorHandler {

    if (contactBusinessModels.count > 0) {
        completionHandler(contactBusinessModels);
        return;
    }
    
    __weak ZAContactBusiness *weakSelf = self;
    
    [self.contactScanner requestAccessContactWithAccessGranted:^{
        dispatch_queue_t queue = dispatch_queue_create("getContacts", nil);
        dispatch_async(queue, ^{
            [weakSelf.contactScanner getContactsWithSortType:sortType completionHandler:^(ZAContact * _Nonnull contact) {
                ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
                if (contactBusinessModel != nil) {
                    [self->contactBusinessModels addObject:contactBusinessModel];
                }
            } errorHandler:^(ZAContactError error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(error);
                });
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(self->contactBusinessModels);
            });
        });
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

- (void)getContactsAndMapTitlesWithSortType:(ZAContactSortType)sortType
                         completionHandler:(void (^)(NSArray * _Nonnull))completionHandler
                              errorHandler:(void (^)(ZAContactError))errorHandler {
    
    [self getContactsWithSortType:sortType completionHandler:^(NSArray<ZAContactBusinessModel *> * _Nonnull contacts) {
        dispatch_queue_t queue = dispatch_queue_create("getContactsAndMapTitle", nil);
        dispatch_async(queue, ^{
            NSMutableArray *titleAndContacts = [NSMutableArray new];
            NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
            NSString *previousTitle;
            NSString * regexA = @"^[A-Z]$";
            NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
            
            for (ZAContactBusinessModel *zaContactBusinessModel in contacts) {
                if ([zaContactBusinessModel.fullNameRemoveDiacritics length] > 0) {
                    NSString *currentTitle = [[zaContactBusinessModel.fullNameRemoveDiacritics substringToIndex:1] uppercaseString];
                    bool isAlphabet = [predA evaluateWithObject:currentTitle];
                    
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nonAlphabetContacts);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                   completionHandler(titleAndContacts);
                });
            }
        });
    } errorHandler:errorHandler];
}

- (void)clearAllContacts {
    [contactBusinessModels removeAllObjects];
}

@end
