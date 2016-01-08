//
//  NSString+NSString_URLEncoding.m
//
//
//
//

#import "NSString+NSString_URLEncoding.h"
#import "IWMF-Swift.h"

@implementation NSString (NSString_URLEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding {    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     encoding));
}

- (NSString *)urlEncode {    
    return [self urlEncodeUsingEncoding:kCFStringEncodingUTF8];
}
@end
