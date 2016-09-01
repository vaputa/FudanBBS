//
//  NSString+URLEncoding.m
//  FudanBBS
//
//  Created by leon on 8/28/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString(URLEncoding)

- (nullable NSString *)stringByAddingPercentEncodingForFormData:(BOOL)plusForSpace {
    NSString *unreserved = @"*-._";
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                      alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    if (plusForSpace) {
        [allowed addCharactersInString:@" "];
    }
    
    NSString *encoded = [self stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    if (plusForSpace) {
        encoded = [encoded stringByReplacingOccurrencesOfString:@" "
                                                     withString:@"+"];
    }
    return encoded;
}

@end
