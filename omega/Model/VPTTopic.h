//
//  VPTTopic.h
//  omega
//
//  Created by leon on 8/27/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPTTopic : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *board;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *count;

@end
