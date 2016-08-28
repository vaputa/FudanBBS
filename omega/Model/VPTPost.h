//
//  VPTPost.h
//  omega
//
//  Created by leon on 8/28/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPTPost : NSObject

@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *board;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSString *reply;
@property (nonatomic, strong) NSDictionary *attributes;
@end
