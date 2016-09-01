//
//  VPTHttpClient.h
//  FudanBBS
//
//  Created by leon on 3/19/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface VPTHttpClient : NSObject

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

+ (instancetype)getInstance;
- (void)loadCookies;
- (void)saveCookies;

@end
