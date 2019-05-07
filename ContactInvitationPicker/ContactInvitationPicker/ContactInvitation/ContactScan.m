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

+ (void)scanContact:(void (^)(NSArray * _Nonnull))completion notGranted:(void (^)(void))notGranted {
    [self requestAccessContact:^(BOOL granted) {
        if (granted) {
            [self getAllContact:^(NSArray *contacts) {
                completion(contacts);
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
    CNContactStore *addressBook = [CNContactStore new];
    [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]]
                                       error:&contactError];
    NSArray * keysToFetch =@[CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    request.sortOrder = CNContactSortOrderFamilyName;
    NSMutableArray<Contact *> *contacts = [NSMutableArray array];
    [addressBook enumerateContactsWithFetchRequest:request
                                             error:&contactError
                                        usingBlock:^(CNContact * __nonnull cnContact, BOOL * __nonnull stop){
        Contact *contact = [self parseContactWithContact:cnContact];
        if (contact != nil) {
            [contacts addObject:contact];
        }
    }];
    completion(contacts);
}

+ (Contact *)parseContactWithContact:(CNContact* )contact
{
    NSMutableDictionary *titlesDict = [NSMutableDictionary new];
    NSString *firstName = contact.givenName;
    NSString *lastName = contact.familyName;
    NSString *phone = [[contact.phoneNumbers.firstObject valueForKey:@"value"] valueForKey:@"digits"];
    if (phone != nil && [phone length] != 0) {
        NSString *prefixCharacter = [firstName substringToIndex:1];
        if ([titlesDict objectForKey:prefixCharacter]) {
            [titlesDict setObject:prefixCharacter forKey:prefixCharacter];
        }
        return [Contact contactWithFirstName:firstName lastName:lastName phoneNumber:phone];
    } else {
        return nil;
    }
}

@end
