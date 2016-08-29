//
//  NetworkService.h
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataReceiveDelegate <NSObject>
- (void)receiveData:(NSString *)data;
@end

@interface VPTNetworkService : NSObject

+ (void)requestWithUrlString:(NSString *)urlString method:(NSString *)method completionHandler:(void (^)(NSString *response, NSError *error))completionHandler;
+ (void)requestWithUrlString:(NSString *)urlString method:(NSString *)method data:(NSDictionary *)data completionHandler:(void (^_Nullable)(NSString *response, NSError *error))completionHandler;

@end

