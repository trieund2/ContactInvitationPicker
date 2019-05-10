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
#import "NSString+Extension.h"

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
    
    NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
    NSMutableArray *contacts = [NSMutableArray new];
    __block NSString *previousTitle = nil;
    
    [contactStore
     enumerateContactsWithFetchRequest:request
     error:&contactError
     usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
         NIContactCellObject *object = [NIContactCellObject objectFromContact:contact];
         if (object) {
             NSString *currentTitle = [object.displayName substringToIndex:1];
             currentTitle = [NSString ignoreUnicode:currentTitle].uppercaseString;
             NSString *allAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
             bool isAlphabet = [allAlphabet containsString:currentTitle];
             
             if (![currentTitle isEqualToString:previousTitle] && isAlphabet) {
                 [contacts addObject:currentTitle];
                 previousTitle = currentTitle;
             }
             if (isAlphabet) {
                 [contacts addObject:object];
             } else {
                 [nonAlphabetContacts addObject:object];
             }
         }
     }];
    
    if (nonAlphabetContacts.count > 0) {
        [nonAlphabetContacts insertObject:@"#" atIndex:0];
    }
    completion([nonAlphabetContacts arrayByAddingObjectsFromArray:contacts]);
}

//+ (void)getAllContact:(void (^)(NSArray *contacts))completion {
//    __block NSError *contactError;
//    CNContactStore *contactStore = [CNContactStore new];
//    NSArray * keysToFetch =@[CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
//    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
//    request.sortOrder = CNContactSortOrderFamilyName;
//
//    NSMutableArray *nonAlphabetContacts = [NSMutableArray new];
//    NSMutableArray *contacts = [NSMutableArray new];
//    __block NSString *previousTitle = nil;
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [contactStore
//         enumerateContactsWithFetchRequest:request
//         error:&contactError
//         usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop) {
//             NIContactCellObject *object = [NIContactCellObject objectFromContact:contact];
//             if (object) {
//                 NSString *currentTitle = [object.displayName substringToIndex:1];
//                 currentTitle = [NSString ignoreUnicode:currentTitle].uppercaseString;
//                 NSString *allAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//                 bool isAlphabet = [allAlphabet containsString:currentTitle];
//
//                 if (![currentTitle isEqualToString:previousTitle] && isAlphabet) {
//                     [contacts addObject:currentTitle];
//                     previousTitle = currentTitle;
//                 }
//                 if (isAlphabet) {
//                     [contacts addObject:object];
//                 } else {
//                     [nonAlphabetContacts addObject:object];
//                 }
//             }
//         }];
//
//        if (nonAlphabetContacts.count > 0) {
//            [nonAlphabetContacts insertObject:@"#" atIndex:0];
//        }
//        completion([nonAlphabetContacts arrayByAddingObjectsFromArray:contacts]);
//    });
//}

@end
