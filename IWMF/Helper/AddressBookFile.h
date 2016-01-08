//
//  AddressBookFile.h
//  IWMF
//
//
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class ContactList;

@interface AddressBookFile : NSObject

-(NSArray *)getContacts;

@end
