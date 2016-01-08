//
//  AddressBookFile.m
//  IWMF
//
//
//
//

#import "AddressBookFile.h"
#import "IWMF-Swift.h"


@implementation AddressBookFile

-(NSArray *)getContacts
{
    ContactList *obj = [[ContactList alloc] init];
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);    
    __block BOOL accessGranted = NO;
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { 
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else {
        accessGranted = YES;
    }    
    if (accessGranted) {
        NSMutableArray *allPeople = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        int nPeople = (int)ABAddressBookGetPersonCount(addressBook);
        for(int i=0; i < nPeople; i++ ){
            ABRecordRef person = (__bridge ABRecordRef)([allPeople objectAtIndex:i]);
            NSString *fname = @"";
            NSString *lname = @"";
            NSString *emails = @"";
            NSString *numbers = @"";
            if(ABRecordCopyValue(person, kABPersonFirstNameProperty) != NULL)
            {
                fname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            }
            if(ABRecordCopyValue(person, kABPersonLastNameProperty) != NULL)
            {
                lname = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
            }
          
            ABMultiValueRef phoneNumbers = (__bridge ABMultiValueRef)((__bridge NSString *)ABRecordCopyValue(person, kABPersonPhoneProperty));
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                if ([numbers length]>0) {
                    numbers =[numbers stringByAppendingString:@","];
                }
                NSString *strPhone = [NSString stringWithFormat:@"%@",ABMultiValueCopyValueAtIndex(phoneNumbers,i)];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@"*" withString:@""];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@"#" withString:@""];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
                strPhone = [strPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
                numbers = [numbers stringByAppendingString:strPhone] ;
            }
            
            ABMultiValueRef emailAddesses = (__bridge ABMultiValueRef)((__bridge NSString *)ABRecordCopyValue(person, kABPersonEmailProperty));
            for (CFIndex i = 0; i < ABMultiValueGetCount(emailAddesses); i++) {
                if ([emails length]>0) {
                    emails =[emails stringByAppendingString:@","];
                }
                emails = [emails stringByAppendingFormat:@"%@",ABMultiValueCopyValueAtIndex(emailAddesses,i)] ;
            }
            
            
           
            
            Contact *contact = [[Contact alloc]init];
            if ([lname length]>0 && [fname length]>0) {
                contact.firstName = fname;
                contact.lastName = lname;
                contact.name = [NSString stringWithFormat:@"%@ %@",fname,lname];
                
            }
            else if ([fname length]>0) {
                contact.firstName = fname;
                contact.lastName = @"";
                contact.name = fname;
            }
            else if ([lname length]>0) {
                contact.firstName = @"";
                contact.lastName = lname;
                contact.name = lname;
            }
            contact.email = emails;
            contact.cellPhone = numbers;
            contact.emailFriendToUnlock = @"";
            contact.selected = @"0";
            [obj insertContactInContactList:contact];
            contact = nil;
        }
    }    
    return obj.contacts;
}
@end
