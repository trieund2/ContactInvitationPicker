//
//  ZAContactBusiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusiness.h"

@interface ZAContactBusiness ()

@end

@implementation ZAContactBusiness

- (instancetype)initWithDelegate:(id<ZAContactScannerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _contactScanner = [[ZAContactScanner alloc] initWithDelegate:self.delegate];
    }
    return self;
}

- (void)getContactsAndMapTitlesWithSortType:(ZAContactSortType)sortType
                         completionHandler:(void (^)(NSArray * _Nonnull))completionHandler
                              errorHandler:(void (^)(ZAContactError))errorHandler {
    
    __weak ZAContactBusiness *weakSelf = self;
    
    [self.contactScanner requestAccessContactWithAccessGranted:^{
        dispatch_queue_t queue = dispatch_queue_create("getContactsAndMapTitles", nil);
        dispatch_async(queue, ^{
            NSMutableArray<ZAContactBusinessModel *>* contactBusinessModels = [NSMutableArray new];
            [weakSelf.contactScanner getContactsWithSortType:sortType completionHandler:^(ZAContact * _Nonnull contact) {
                ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
                if (contactBusinessModel != nil) {
                    [contactBusinessModels addObject:contactBusinessModel];
                }
            } errorHandler:^(ZAContactError error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(error);
                });
            }];
            
            NSMutableArray *titleAndContacts = [NSMutableArray new];
            NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
            NSString *previousTitle;
            NSString * regexA = @"^[A-Z]$";
            NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
            
            for (ZAContactBusinessModel *zaContactBusinessModel in contactBusinessModels) {
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
                    for (int i = 0; i < 8; ++i) {
                        [nonAlphabetContacts addObjectsFromArray:nonAlphabetContacts];
                    }
                    NSLog(@"contacts size %li", nonAlphabetContacts.count);
                    completionHandler(nonAlphabetContacts);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(titleAndContacts);
                });
            }
        });
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

@end
