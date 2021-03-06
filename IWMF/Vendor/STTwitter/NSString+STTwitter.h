//
//  NSString+STTwitter.h
//
//
//
//
//

#import <Foundation/Foundation.h>

extern NSUInteger kSTTwitterDefaultShortURLLength;
extern NSUInteger kSTTwitterDefaultShortURLLengthHTTPS;

extern NSString *kSTPOSTDataKey; // dummy parameter to tell a key used to post raw media, necessary because media are ignored in OAuth signatures
extern NSString *kSTPOSTMediaFileNameKey; // dummy parameter to tell the name of a file to be uploaded, optional but more correct than none

@interface NSString (STTwitter)

- (NSString *)st_firstMatchWithRegex:(NSString *)regex error:(NSError **)e;

// use values from GET help/configuration
- (NSInteger)st_numberOfCharactersInATweetWithShortURLLength:(NSUInteger)shortURLLength
                                         shortURLLengthHTTPS:(NSUInteger)shortURLLengthHTTS;

// use default values for URL shortening
- (NSInteger)st_numberOfCharactersInATweet;

@end
