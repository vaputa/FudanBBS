//
//  VPTHttpClient.m
//  FudanBBS
//
//  Created by leon on 3/19/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTHttpClient.h"

@interface VPTHttpClient()
{
    AFURLSessionManager *sm;
}
@end

@implementation VPTHttpClient

static VPTHttpClient *instance;

+ (instancetype)getInstance {
    if (instance == nil) {
        instance = [[VPTHttpClient alloc] initPrivately];
        [instance loadCookies];
    }
    return instance;
}

- (instancetype)initPrivately {
    self = [super init];
    if (self) {
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)setSessionManager:(AFURLSessionManager *)sessionManager {
    sm = sessionManager;
}

- (void)saveCookies{
    NSData *savecookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: savecookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies{
    NSArray *loadcookiesarray = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookies in loadcookiesarray){
        [cookieStorage setCookie: cookies];
    }
}

@end
