//
//  NSString+URLEncoding.h
//  omega
//
//  Created by leon on 8/28/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForFormData:(BOOL)plusForSpace;
@end
