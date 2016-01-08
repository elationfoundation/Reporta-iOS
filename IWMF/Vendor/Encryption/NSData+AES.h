//
// AES256 EnCrypt / DeCrypt
//
//
//
//

#import <UIKit/UIKit.h>
#include <Availability.h>
#include <sys/types.h>
#include <CommonCrypto/CommonDigest.h>
@interface NSData (AESTest)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end