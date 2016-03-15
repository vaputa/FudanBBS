//
//  NetworkService.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "AFNetworking.h"
#import "Ono.h"

#import "VPTNetworkService.h"

@interface VPTNetworkService ()
@end

@implementation VPTNetworkService

+ (AFURLSessionManager *)getSessionManager {
    static AFURLSessionManager *manager;
    if (manager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return manager;
}

+ (void)request:(NSString *)urlString delegate:(id<DataReceiveDelegate>)delegate{
    AFURLSessionManager *manager = [VPTNetworkService getSessionManager];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request
                                                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                        NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                        [delegate receiveData:result];
                                                    }];
    [downloadTask resume];
}

+ (void)post:(NSString *)urlString data:(NSDictionary *)dictionary delegate:(id<DataReceiveDelegate>)delegate{
    AFURLSessionManager *manager = [VPTNetworkService getSessionManager];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSData *data = [[[NSString alloc] initWithFormat:@"id=%@&pw=%@", dictionary[@"username"], dictionary[@"password"]] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request
                                                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                        NSString *result = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                        [delegate receiveData:result];
                                                    }];
    [downloadTask resume];
}


@end
