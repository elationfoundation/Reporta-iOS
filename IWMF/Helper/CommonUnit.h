//
//  CommonUnit.h
//  IWMF
//
//  This class is used for common functions like device is jailbroken or not, check device type, store media by encryption.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <sys/stat.h>
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSMutableData+Crypto.h"

#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height == 568.0f
#define IS_IPHONE_6 [[UIScreen mainScreen] bounds].size.height == 667.0f
#define IS_IPHONE_6Plus [[UIScreen mainScreen] bounds].size.height == 736.0f
#define IS_IPHONE_4 [[UIScreen mainScreen] bounds].size.height == 480.0f

#define KEY_PENDING_MEDIA @"com.mobileapp.iwmf.pending.media"

@interface CommonUnit : NSObject

+(NSString *)getStingFromArray:(NSMutableArray *)arr join:(NSString *)str;
+(BOOL)isIphone4;
+(BOOL)isIphone5;
+(BOOL)isIphone6;
+(BOOL)isIphone6plus;
+(NSBundle *)setLanguage:(NSString*)language;

#pragma mark -Archived File Funtions
+(void)saveDataWithKey:(NSString *)key InFile:(NSString *)file List:(NSMutableArray *)list;
+(NSMutableArray *)getDataFroKey:(NSString *)key FromFile:(NSString *)file;
+(void)appendDataWithKey:(NSString *)key InFile:(NSString *)file List:(NSMutableArray *)list;
+(void)removeDataForKey:(NSString *)key FromFile:(NSString *)file;
+(void)removeFile:(NSString *)mideaName ForKey:(NSString *)key FromFile:(NSString *)file;
+(void)deleteSingleFile:(NSString *)strFileName FromDirectory:(NSString*)dirName;
+(NSData*)readFileDataFromDirectory:(NSString*)dirName fileName:(NSString*)fileName;
+(void)storeVideo:(NSString *)strName urlstring:(NSString *)stringURL dirName:(NSString *)dirName encryptionKey:(NSString *)key;
+(void)storeImage:(UIImage *)Image withName:(NSString *)fileName inDirectory:(NSString *)dirName encryptionKey:(NSString *)key;
+(void)storeAudio:(NSString *)strName urlstring:(NSString *)stringURL dirName:(NSString *)dirName encryptionKey:(NSString *)key;
+(NSMutableDictionary *)getSectionFromDictionary:(NSArray *)arr isAllConact:(BOOL)IsAllcontact;
+( NSDictionary *)getSectionForCircleList:(NSArray *)arr;
+(NSMutableArray *)GetCountryList:(NSString *)LanguageCode;
+(void)deleteSingleAudioFile:(NSString *)strFileName;
+(NSMutableAttributedString *) boldSubstring:(NSString *)boldSubstring string:(NSString *)string fontName:(UIFont *)font;
+(BOOL)isDeviceJailbroken;
+(void)encryptFile:(NSString *)filePath EncryptionKey:(NSString *)key;
+(void)decryptFile:(NSString *)data DecryptionKey:(NSString *)key;
+(NSData *)getDataFromEncryptedFile:(NSString*)dirName fileName:(NSString*)fileName decryptionKey:(NSString *)key;
@end
