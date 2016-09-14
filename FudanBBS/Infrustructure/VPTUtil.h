//
//  VPTUtil.h
//  FudanBBS
//
//  Created by leon on 3/20/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isIPv6 ([[VPTUtil getIPAddress:YES] containsString:@":"])

@interface VPTUtil : NSObject
+ (NSDate *)dateFromString:(NSString *)date;
+ (NSDate *)dateFromStandardString:(NSString *)date;
+ (NSString *)dateToString:(NSDate *)date;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end
