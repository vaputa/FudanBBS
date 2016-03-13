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

@interface NetworkService : NSObject

+ (void)request:(NSString *)url delegate:(id<DataReceiveDelegate>)delegate;
+ (void)post:(NSString *)url data:(NSDictionary *)dictionary delegate:(id<DataReceiveDelegate>)delegate;
@end

