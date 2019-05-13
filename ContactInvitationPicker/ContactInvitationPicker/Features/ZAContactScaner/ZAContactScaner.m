//
//  ZAContactScaner.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ZAContactScaner.h"

@implementation ZAContactScaner

+ (void)requestAccessContactWithCompletionHandler:(void (^)(BOOL))completionHandler
                                 errorHandler:(void (^)(NSError * _Nonnull))errorHandler {
    if (@available(iOS 9.0, *)) {
        CNEntityType entityType = CNEntityTypeContacts;
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:entityType];
        
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted,
                                                                                    NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error != NULL) {
                        errorHandler(error);
                    } else {
                        completionHandler(granted);
                    }
                });
            }];
        } else {
            completionHandler(authorizationStatus == CNAuthorizationStatusAuthorized);
        }
    } else {
        ABAuthorizationStatus addressBookAthorStatus = ABAddressBookGetAuthorizationStatus();
        if (addressBookAthorStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error != NULL) {
                        errorHandler(CFBridgingRelease(error));
                    } else {
                        completionHandler(granted);
                    }
                });
            });
        } else {
            completionHandler(addressBookAthorStatus == kABAuthorizationStatusAuthorized);
        }
    }
}

+ (void)getAllContactsWithCompletionHandler:(void (^)(NSArray<ZAContact *> * _Nonnull))completionHandler
                               errorHandler:(void (^)(NSError * _Nonnull))errorHandler {
    if (@available(iOS 9.0,*)) {
        NSError *contactError;
        CNContactStore *contactStore = [CNContactStore new];
        NSArray * keysToFetch =@[CNContactPhoneNumbersKey,
                                 [CNContactFormatter descriptorForRequiredKeysForStyle:(CNContactFormatterStyleFullName)]];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        request.sortOrder = CNContactSortOrderUserDefault;
        
        NSMutableArray<ZAContact *> *zaContacts = [NSMutableArray new];
        
        [contactStore
         enumerateContactsWithFetchRequest:request
         error:&contactError
         usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
             ZAContact *zaContact = [ZAContact objectFromContact:contact];
             if (zaContact != NULL) {
                 [zaContacts addObject:zaContact];
             }
         }];
        if (contactError != NULL) {
            errorHandler(contactError);
        } else {
            completionHandler(zaContacts);
        }
    } else {
        CFErrorRef error = NULL;
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
        NSArray *allContacts = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllGroups(addressBookRef));
        NSMutableArray<ZAContact*> *zaContacts = [NSMutableArray new];
        
        for (NSUInteger i = 0; i < [allContacts count]; i++) {
            ABRecordRef recordRef = (__bridge ABRecordRef)([allContacts objectAtIndex:i]);
            ZAContact *contact = [ZAContact objectFromABRecordRef:recordRef];
            [zaContacts addObject:contact];
        }
        CFRelease(addressBookRef);
        completionHandler(zaContacts);
    }
}

@end
