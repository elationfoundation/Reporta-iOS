//
//  STTwitterOSRequest.h
//  
//
//
//  
//

#import <Foundation/Foundation.h>

@class ACAccount;

@interface STTwitterOSRequest : NSObject <NSURLConnectionDelegate>

- (id)initWithAPIResource:(NSString *)resource
            baseURLString:(NSString *)baseURLString
               httpMethod:(NSInteger)httpMethod
               parameters:(NSDictionary *)params
                  account:(ACAccount *)account
         timeoutInSeconds:(NSTimeInterval)timeoutInSeconds
      uploadProgressBlock:(void(^)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))uploadProgressBlock
          completionBlock:(void(^)(id request, NSDictionary *requestHeaders, NSDictionary *responseHeaders, id response))completionBlock
               errorBlock:(void(^)(id request, NSDictionary *requestHeaders, NSDictionary *responseHeaders, NSError *error))errorBlock;

- (NSURLConnection *)startRequest;
- (NSURLRequest *)preparedURLRequest;

@end
