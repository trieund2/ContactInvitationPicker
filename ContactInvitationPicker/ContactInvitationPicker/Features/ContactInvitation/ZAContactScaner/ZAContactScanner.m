//
//  ZAContactScanner.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactScanner.h"

@interface ZAContactScanner ()

@property (nonatomic) NSMutableSet *delegates;
@property (nonatomic) dispatch_queue_t queue;

@end

@implementation ZAContactScanner

+ (instancetype)sharedInstance {
    static ZAContactScanner *contactScanner;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        contactScanner = [ZAContactScanner new];
    });
    return contactScanner;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegates = NICreateNonRetainingMutableSet();
        self.queue = dispatch_queue_create("ZAContactScanner", DISPATCH_QUEUE_SERIAL);
        
        if (@available(iOS 9.0, *)) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(contactStoreDidChange:)
                                                         name:CNContactStoreDidChangeNotification
                                                       object:nil];
        } else {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
            ABAddressBookRegisterExternalChangeCallback(addressBook, addressBookContactsExtenalChangeCallback, (__bridge void *)(self));
        }
    }
    
    return self;
}

- (void)contactStoreDidChange:(NSNotification *)notification {
    [self handleContactChangeCallback];
}

void addressBookContactsExtenalChangeCallback(ABAddressBookRef addressbook,CFDictionaryRef info,void *context) {
    ZAContactScanner *scanner = (__bridge ZAContactScanner *)context;
    [scanner handleContactChangeCallback];
}

- (void)handleContactChangeCallback {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        for (id<ZAContactScannerDelegate> delegate in weakSelf.delegates) {
            if ([delegate respondsToSelector:@selector(contactDidChange)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate contactDidChange];
                });
            }
        }
    });
}

#pragma mark - Interface methods

- (void)addDelegate:(id<ZAContactScannerDelegate>)delegate {
    if (![delegate conformsToProtocol:@protocol(ZAContactScannerDelegate)]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        [weakSelf.delegates addObject:delegate];
    });
}

- (void)removeDelegate:(id<ZAContactScannerDelegate>)delegate {
    if (![delegate conformsToProtocol:@protocol(ZAContactScannerDelegate)]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(self.queue, ^{
        [weakSelf.delegates removeObject:delegate];
    });
}

- (void)requestAccessContactWithAccessGranted:(void (^)(void))accessGranted
                                 accessDenied:(void (^)(void))accessDenied {
    if (@available(iOS 9.0, *)) {
        CNEntityType entityType = CNEntityTypeContacts;
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:entityType];
        
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted,
                                                                                    NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == NULL && granted) {
                        accessGranted();
                    } else {
                        accessDenied();
                    }
                });
            }];
        } else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
            accessGranted();
        } else {
            accessDenied();
        }
    } else {
        ABAuthorizationStatus addressBookAthorStatus = ABAddressBookGetAuthorizationStatus();
        if (addressBookAthorStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == NULL && granted) {
                        accessGranted();
                    } else {
                        accessDenied();
                    }
                });
            });
        } else if (addressBookAthorStatus == kABAuthorizationStatusAuthorized) {
            accessGranted();
        } else {
            accessDenied();
        }
    }
}

- (void)getContactsWithSortType:(ZAContactSortType)sortType
              completionHandler:(void (^)(ZAContact * _Nonnull))completionHandler
                   errorHandler:(void (^)(ZAContactError))errorHandler {
    
    if (@available(iOS 9.0,*)) {
        NSError *contactError;
        CNContactStore *contactStore = [CNContactStore new];
        NSArray * keysToFetch =@[CNContactPhoneNumbersKey,
                                 CNContactGivenNameKey,
                                 CNContactFamilyNameKey,
                                 CNContactMiddleNameKey,
                                 CNContactImageDataKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        switch (sortType) {
            case ZAContactSortTypeNone:
                request.sortOrder = CNContactSortOrderNone;
                break;
            case ZAContactSortTypeGivenName:
                request.sortOrder = CNContactSortOrderGivenName;
                break;
            case ZAContactSortTypeFamilyName:
                request.sortOrder = CNContactSortOrderFamilyName;
                break;
        };
        
        [contactStore
         enumerateContactsWithFetchRequest:request
         error:&contactError
         usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
             if (contactError) {
                 if (contactError.code == CNErrorCodeAuthorizationDenied) {
                     errorHandler(ZAContactErrorNotPermitterByUser);
                 } else if (contactError.code == CNErrorCodePolicyViolation) {
                     errorHandler(ZAContactErrorNotPermittedByStore);
                 }
             } else {
                 ZAContact *zaContact = [ZAContact objectFromContact:contact];
                 if (zaContact) {
                     completionHandler(zaContact);
                 }
             }
             
         }];
    } else {
        CFErrorRef contactError = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &contactError);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        NSArray *allContacts;
        
        switch (sortType) {
            case ZAContactSortTypeNone:
                allContacts = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
                break;
            case ZAContactSortTypeGivenName:
                allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook,
                                                                                                            source,
                                                                                                            kABPersonSortByFirstName);
                break;
            case ZAContactSortTypeFamilyName:
                allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook,
                                                                                                            source,
                                                                                                            kABPersonSortByLastName);
                break;
        };
        
        if (contactError) {
            NSError *error = (__bridge NSError *)(contactError);
            if (error.code == kABOperationNotPermittedByUserError) {
                errorHandler(ZAContactErrorNotPermittedByStore);
            } else if (error.code == kABOperationNotPermittedByStoreError) {
                errorHandler(ZAContactErrorNotPermitterByUser);
            }
        } else {
            for (NSUInteger i = 0; i < [allContacts count]; i++) {
                ABRecordRef recordRef = (__bridge ABRecordRef)([allContacts objectAtIndex:i]);
                ZAContact *contact = [ZAContact objectFromABRecordRef:recordRef];
                if (contact != NULL) {
                    completionHandler(contact);
                }
            }
        }
    }
}

@end
