//
//  ZAContactAdapter.m
//  ContactInvitationPicker
//
//  Created by MACOS on 5/12/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactAdapter.h"

@interface ZAContactAdapter ()

@property (nonatomic, readonly) ZAContactScanner *contactScanner;
@property (nonatomic, readonly) dispatch_queue_t queue;

@end

@implementation ZAContactAdapter

#pragma mark - Init

+ (instancetype)shareInstance {
    static ZAContactAdapter *contactAdapter;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        contactAdapter = [ZAContactAdapter new];
    });
    return contactAdapter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactScanner = [ZAContactScanner new];
        _queue = dispatch_queue_create("getContactsAndMapTitles", nil);
    }
    return self;
}

#pragma mark - Override

- (void)setDelegate:(id<ZAContactScannerDelegate>)delegate {
    _delegate = delegate;
    self.contactScanner.delegate = self.delegate;
}

#pragma mark - Interface methods

- (void)getOrderContactsWithSortType:(ZAContactSortType)sortType
                   completionHandler:(void (^)(NSArray * _Nonnull))completionHandler
                        errorHandler:(void (^)(ZAContactError))errorHandler {
    
    __weak ZAContactAdapter *weakSelf = self;
    
    [self.contactScanner requestAccessContactWithAccessGranted:^{
        dispatch_async(weakSelf.queue, ^{
            NSMutableArray *contactAdapterModels = [NSMutableArray new];
            NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
            NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Z]$"];
            __block NSString *previousTitle;
            
            [weakSelf.contactScanner getContactsWithSortType:sortType completionHandler:^(ZAContact * _Nonnull contact) {
                ZAContactAdapterModel *contactAdapterModel = [ZAContactAdapterModel objectWithZaContact:contact];
                if (contactAdapterModel) {
                    if ([contactAdapterModel.fullNameRemoveDiacritics length] > 0) {
                        NSString *currentTitle = [[contactAdapterModel.fullNameRemoveDiacritics substringToIndex:1] uppercaseString];
                        bool isAlphabet = [predA evaluateWithObject:currentTitle];
                        
                        if (![currentTitle isEqualToString:previousTitle] && isAlphabet) {
                            [contactAdapterModels addObject:currentTitle];
                            previousTitle = currentTitle;
                        }
                        if (isAlphabet) {
                            [contactAdapterModels addObject:contactAdapterModel];
                        } else {
                            [nonAlphabetContacts addObject:contactAdapterModel];
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
                [nonAlphabetContacts addObjectsFromArray:contactAdapterModels];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(nonAlphabetContacts);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(contactAdapterModels);
                });
            }
        });
    } accessDenied:^{
        errorHandler(ZAContactErrorNotPermitterByUser);
    }];
}

@end
