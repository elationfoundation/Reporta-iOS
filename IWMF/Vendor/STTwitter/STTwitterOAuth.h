//
//  STTwitterRequest.h
//  STTwitterRequests
//
//
//
//

#import <Foundation/Foundation.h>
#import "STTwitterProtocol.h"


NS_ENUM(NSUInteger, STTwitterOAuthErrorCode) {
    STTwitterOAuthCannotPostAccessTokenRequestWithoutPIN,
    STTwitterOAuthBadCredentialsOrConsumerTokensNotXAuthEnabled
};

@interface STTwitterOAuth : NSObject <STTwitterProtocol>

@property (nonatomic) NSTimeInterval timeoutInSeconds;

+ (instancetype)twitterOAuthWithConsumerName:(NSString *)consumerName
                                 consumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret;

+ (instancetype)twitterOAuthWithConsumerName:(NSString *)consumerName
                                 consumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret
                                  oauthToken:(NSString *)oauthToken
                            oauthTokenSecret:(NSString *)oauthTokenSecret;

+ (instancetype)twitterOAuthWithConsumerName:(NSString *)consumerName
                                 consumerKey:(NSString *)consumerKey
                              consumerSecret:(NSString *)consumerSecret
                                    username:(NSString *)username
                                    password:(NSString *)password;

- (void)postTokenRequest:(void(^)(NSURL *url, NSString *oauthToken))successBlock
authenticateInsteadOfAuthorize:(BOOL)authenticateInsteadOfAuthorize
              forceLogin:(NSNumber *)forceLogin // optional, default @(NO)
              screenName:(NSString *)screenName // optional, default nil
           oauthCallback:(NSString *)oauthCallback
              errorBlock:(void(^)(NSError *error))errorBlock;

// convenience
- (void)postTokenRequest:(void(^)(NSURL *url, NSString *oauthToken))successBlock
           oauthCallback:(NSString *)oauthCallback
              errorBlock:(void(^)(NSError *error))errorBlock;


- (void)postAccessTokenRequestWithPIN:(NSString *)pin
                         successBlock:(void(^)(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName))successBlock
                           errorBlock:(void(^)(NSError *error))errorBlock;

- (void)postXAuthAccessTokenRequestWithUsername:(NSString *)username
                                       password:(NSString *)password
                                   successBlock:(void(^)(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName))successBlock
                                     errorBlock:(void(^)(NSError *error))errorBlock;

// reverse auth phase 1
- (void)postReverseOAuthTokenRequest:(void(^)(NSString *authenticationHeader))successBlock
                          errorBlock:(void(^)(NSError *error))errorBlock;

- (BOOL)canVerifyCredentials;

- (void)verifyCredentialsWithSuccessBlock:(void(^)(NSString *username))successBlock errorBlock:(void(^)(NSError *error))errorBlock;



- (NSDictionary *)OAuthEchoHeadersToVerifyCredentials;

@end

@interface NSString (STTwitterOAuth)
+ (NSString *)st_random32Characters;
- (NSString *)st_signHmacSHA1WithKey:(NSString *)key;
- (NSDictionary *)st_parametersDictionary;
- (NSString *)st_urlEncodedString;
@end

@interface NSURL (STTwitterOAuth)
- (NSString *)st_normalizedForOauthSignatureString;
- (NSArray *)st_rawGetParametersDictionaries;
@end
