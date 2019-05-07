//
//  ContactScan.m
//  ContactInvitationPicker
//
//  Created by CPU12202 on 5/7/19.
//  Copyright © 2019 com.trieund. All rights reserved.
//

#import "ContactScan.h"
#import <Contacts/Contacts.h>
#import "Contact.h"

@implementation ContactScan

#pragma mark Interface methods

+ (void)scanContact:(void (^)(NSArray * _Nonnull, NSArray * _Nonnull))completion
         notGranted:(void (^)(void))notGranted {
    [self requestAccessContact:^(BOOL granted) {
        if (granted) {
            [self getAllContact:^(NSArray *contacts, NSArray *titles) {
                completion(contacts, titles);
            }];
        } else {
            notGranted();
        }
    }];
}

#pragma mark Private methods

+ (void)requestAccessContact:(void (^)(BOOL granted))completion {
    CNEntityType entityType = CNEntityTypeContacts;
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:entityType];
    
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [CNContactStore new];
        [contactStore requestAccessForEntityType:entityType
                               completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                   completion(granted);
                               }];
    } else if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        completion(YES);
    } else {
        completion(NO);
    }
}

+ (void)getAllContact:(void (^)(NSArray *contacts, NSArray *titles))completion {
    NSError *contactError;
    CNContactStore *contactStore = [CNContactStore new];
    [contactStore containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers:
                                               @[contactStore.defaultContainerIdentifier]]
                                        error:&contactError];
    NSArray * keysToFetch =@[CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    request.sortOrder = CNContactSortOrderFamilyName;
    
    NSMutableArray *returnContacts = [NSMutableArray new];
    NSMutableArray *currentContacts = [NSMutableArray new];
    NSMutableArray *titles = [NSMutableArray new];
    __block NSString *previousTitle = nil;
    
    [contactStore
     enumerateContactsWithFetchRequest:request
     error:&contactError
     usingBlock:^(CNContact * __nonnull cnContact, BOOL * __nonnull stop) {
         
         NSString *firstName = cnContact.givenName;
         NSString *lastName = cnContact.familyName;
         NSString *phone = [[cnContact.phoneNumbers.firstObject valueForKey:@"value"] valueForKey:@"digits"];
         if (phone != nil
             && [phone length] != 0
             && ([firstName length] != 0 || [lastName length] != 0)) {
             Contact *contact = [Contact contactWithFirstName:firstName lastName:lastName phoneNumber:phone];
             NSString *currentTitle = [contact.fullName substringToIndex:1];
             
             if (currentTitle != previousTitle) {
                 if (previousTitle != nil) {
                     [returnContacts addObject:currentContacts];
                     [currentContacts removeAllObjects];
                 }
                 previousTitle = currentTitle;
                 [titles addObject:currentTitle];
             }
             [currentContacts addObject:contact];
         }
     }];
    
    if (currentContacts.count > 0) {
        [returnContacts addObject:currentContacts];
    }
    
    completion(returnContacts, titles);
}

@end
