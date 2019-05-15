//
//  ZAContactScaner.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactScaner.h"

@implementation ZAContactScaner

+ (void)requestAccessContactWithAccessGranted:(void (^)(void))accessGranted
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

+ (void)getAllContactsWithSortType:(ZAContactSortType)sortType
                 CompletionHandler:(void (^)(NSArray<ZAContact *> * _Nonnull))completionHandler
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
        
        NSMutableArray<ZAContact *> *zaContacts = [NSMutableArray new];
        
        [contactStore
         enumerateContactsWithFetchRequest:request
         error:&contactError
         usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
             ZAContact *zaContact = [ZAContact objectFromContact:contact];
             if (zaContact) {
                 [zaContacts addObject:zaContact];
             }
         }];
        if (contactError) {
            if (contactError.code == CNErrorCodeAuthorizationDenied) {
                errorHandler(ZAContactErrorNotPermitterByUser);
            } else if (contactError.code == CNErrorCodePolicyViolation) {
                errorHandler(ZAContactErrorNotPermittedByStore);
            }
        } else {
            completionHandler(zaContacts);
        }
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
            NSMutableArray<ZAContact*> *zaContacts = [NSMutableArray new];
            for (NSUInteger i = 0; i < [allContacts count]; i++) {
                ABRecordRef recordRef = (__bridge ABRecordRef)([allContacts objectAtIndex:i]);
                ZAContact *contact = [ZAContact objectFromABRecordRef:recordRef];
                [zaContacts addObject:contact];
            }
            completionHandler(zaContacts);
        }
        
        CFRelease(addressBook);
    }
}

@end
