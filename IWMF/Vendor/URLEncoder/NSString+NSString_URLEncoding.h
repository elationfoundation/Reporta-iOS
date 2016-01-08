//
//  NSString+NSString_URLEncoding.h
//
//
//
// 
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_URLEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding;
- (NSString *)urlEncode;
@end
