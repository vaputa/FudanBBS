//
//  NetworkService.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Ono/Ono.h>

#import "VPTNetworkService.h"
#import "VPTServiceManager.h"
#import "VPTHttpClient.h"
#import "NSString+URLEncoding.h"

@interface VPTNetworkService ()
@end

@implementation VPTNetworkService

static VPTHttpClient *httpClient;

+ (void)initialize {
    httpClient = [VPTHttpClient getInstance];
}

+ (void)requestWithUrlString:(NSString *)urlString method:(NSString *)method completionHandler:(void (^_Nullable)(NSString *response, NSError *error))completionHandler {
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:method];
    NSURLSessionDataTask *downloadTask = [httpClient.sessionManager dataTaskWithRequest:request
                                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                          NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                                          NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                                          if (completionHandler) {
                                                                              completionHandler(result, error);
                                                                          }
                                                                          [httpClient saveCookies];
                                                                      }];
    [downloadTask resume];
}

+ (void)requestWithUrlString:(NSString *)urlString method:(NSString *)method data:(NSDictionary *)data completionHandler:(void (^_Nullable)(NSString *response, NSError *error))completionHandler {
    NSURL *URL = [NSURL URLWithString:urlString];
    __block NSString *buf = @"";
    [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        buf = [buf stringByAppendingString:[[NSString alloc] initWithFormat:@"%@%@=%@", ([buf isEqualToString:@""] ? @"" : @"&"),
                                            [key stringByAddingPercentEncodingForFormData:YES],
                                            [obj stringByAddingPercentEncodingForFormData:YES]]];
    }];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:method];
    [request setHTTPBody:[buf dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *downloadTask = [httpClient.sessionManager dataTaskWithRequest:request
                                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                          NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                                          NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                                          if (completionHandler) {
                                                                              completionHandler(result, error);
                                                                          }
                                                                          [httpClient saveCookies];
                                                                      }];
    [downloadTask resume];
}

+ (void)request:(NSString *)urlString completion:(void (^_Nullable)(NSString *, NSError *_Nullable))completion {
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *downloadTask = [httpClient.sessionManager dataTaskWithRequest:request
                                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                          NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                                          NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                                          completion(result, error);
                                                                          [httpClient saveCookies];
                                                                      }];
    [downloadTask resume];
}


+ (void)post:(NSString *)urlString data:(NSDictionary *)dictionary completion:(void (^_Nullable)(NSString *, NSError *_Nullable))completion {
    NSURL *URL = [NSURL URLWithString:urlString];
    __block NSString *buf = @"";
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        buf = [buf stringByAppendingString:[[NSString alloc] initWithFormat:@"%@%@=%@", ([buf isEqualToString:@""] ? @"" : @"&"), key, obj]];
    }];
    NSData *data = [buf dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLSessionDataTask *downloadTask = [httpClient.sessionManager dataTaskWithRequest:request
                                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                          NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                                          NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                                          completion(result, error);
                                                                          [httpClient saveCookies];
                                                                      }];
    [downloadTask resume];
}

@end
