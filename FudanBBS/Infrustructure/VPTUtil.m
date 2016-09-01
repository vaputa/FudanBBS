//
//  VPTUtil.m
//  FudanBBS
//
//  Created by leon on 3/20/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTUtil.h"

@implementation VPTUtil

+ (NSDate *)dateFromStandardString:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    return [formatter dateFromString:date];
}

+ (NSDate *)dateFromString:(NSString *)date {
    date = [date substringToIndex:[date length] - 4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
    return [formatter dateFromString:date];
}

+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end