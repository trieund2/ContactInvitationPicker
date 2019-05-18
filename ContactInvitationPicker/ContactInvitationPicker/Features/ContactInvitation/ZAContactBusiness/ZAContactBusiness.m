//
//  ZAContactBusiness.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactBusiness.h"

@interface ZAContactBusiness ()

@property (nonatomic, readonly) ZAContactScanner *contactScanner;
@property (nonatomic, readonly) dispatch_queue_t queue;

@end

@implementation ZAContactBusiness

- (instancetype)initWithDelegate:(id<ZAContactScannerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _contactScanner = [[ZAContactScanner alloc] initWithDelegate:self.delegate];
        _queue = dispatch_queue_create("getContactsAndMapTitles", nil);
    }
    return self;
}

- (void)getOrderContactsWithSortType:(ZAContactSortType)sortType
                   completionHandler:(void (^)(NSArray * _Nonnull))completionHandler
                        errorHandler:(void (^)(ZAContactError))errorHandler {
    
    __weak ZAContactBusiness *weakSelf = self;
    
    [self.contactScanner requestAccessContactWithAccessGranted:^{
        dispatch_async(weakSelf.queue, ^{
            NSMutableArray *contactBusinessModels = [NSMutableArray new];
            NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
            NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Z]$"];
            __block NSString *previousTitle;
            
            [weakSelf.contactScanner getContactsWithSortType:sortType completionHandler:^(ZAContact * _Nonnull contact) {
                ZAContactBusinessModel *contactBusinessModel = [ZAContactBusinessModel objectWithZaContact:contact];
                if (contactBusinessModel) {
                    if ([contactBusinessModel.fullNameRemoveDiacritics length] > 0) {
                        NSString *currentTitle = [[contactBusinessModel.fullNameRemoveDiacritics substringToIndex:1] uppercaseString];
                        bool isAlphabet = [predA evaluateWithObject:currentTitle];
                        
                        if (![currentTitle isEqualToString:previousTitle] && isAlphabet) {
                            [contactBusinessModels addObject:currentTitle];
                            previousTitle = currentTitle;
                        }
                        if (isAlphabet) {
                            [contactBusinessModels addObject:contactBusinessModel];
                        } else {
                            [nonAlphabetContacts addObject:contactBusinessModel];
                        }
                    }
                }
            } errorHandler:^(ZAContactError error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorHandler(error);
                });
            }];
            
            if ([nonAlphabetContacts count] > 0) {
                [nonAlphabetContacts insertObject:@"#" atIndex:0];
                [nonAlphabetContacts addObjectsFromArray:contactBusinessModels];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nonAlphabetContacts);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(contactBusinessModels);
                });
            }
        });
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

@end
