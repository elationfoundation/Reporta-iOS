
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface NSMutableData (Crypto)
- (BOOL)encryptWithKey:(NSString *)key;
- (BOOL)decryptWithKey:(NSString *)key;
@end