//
//  ContactScan.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactScan.h"
#import <Contacts/Contacts.h>
#import "NIContactCellObject.h"

@implementation ContactScan

#pragma mark Interface methods

+ (void)scanContact:(void (^)(NSArray * _Nonnull contacts))completion
         notGranted:(void (^)(void))notGranted {
    [self requestAccessContact:^(BOOL granted) {
        if (granted) {
            [self getAllContact:^(NSArray *contacts) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(contacts);
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                notGranted();
            });
        }
    }];
}

#pragma mark Private methods

+ (void)requestAccessContact:(void (^)(BOOL granted))completion {
    CNEntityType entityType = CNEntityTypeContacts;
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:entityType];
    
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [CNContactStore new];
        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
            completion(granted);
        }];
    } else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        completion(YES);
    } else {
        completion(NO);
    }
}

+ (void)getAllContact:(void (^)(NSArray *contacts))completion {
    NSError *contactError;
    CNContactStore *contactStore = [CNContactStore new];
    NSArray * keysToFetch =@[CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    request.sortOrder = CNContactSortOrderFamilyName;
    
    NSMutableArray *contacts = [NSMutableArray new];
    __block NSString *previousTitle = nil;
    
    [contactStore
     enumerateContactsWithFetchRequest:request
     error:&contactError
     usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
         NIContactCellObject *object = [NIContactCellObject objectFromContact:contact];
         if (object) {
             NSString *currentTitle = [object.displayName substringToIndex:1];
             if (![currentTitle isEqualToString:previousTitle]) {
                 [contacts addObject:currentTitle];
                 previousTitle = currentTitle;
             }
             [contacts addObject:object];
         }
     }];
    
    completion(contacts);
}

@end
