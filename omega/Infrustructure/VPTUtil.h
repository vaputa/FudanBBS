//
//  VPTUtil.h
//  omega
//
//  Created by leon on 3/20/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPTUtil : NSObject
+ (NSDate *)dateFromString:(NSString *)date;
+ (NSString *)dateToString:(NSDate *)date;
@end