//
//  VPTDataManager.m
//  FudanBBS
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTDataManager.h"

@interface VPTDataManager()
@end

@implementation VPTDataManager

+ (NSArray *)getFavouriteTopicList {
    NSMutableArray *array = [[self defaultStorage] objectForKey:@"favouriteTopics"];
    return array;
}
+ (BOOL)AddToFavouriteTopicListWithBoardName:(NSString *)boardName boardId:boardId topicId:(NSString *)topicId title:(NSString *)title {
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteTopics"]];
    [array addObject:@ {
        @"boardId": boardId,
        @"boardName": boardName == nil? @"":boardName,
        @"id": topicId,
        @"title": title,
    }];
    [storage setObject:array forKey:@"favouriteTopics"];
    [storage synchronize];
    return YES;
}

+ (NSUserDefaults *)defaultStorage {
    static NSUserDefaults *storage;
    if (storage == nil) {
        storage = [NSUserDefaults standardUserDefaults];
        if ([storage objectForKey:@"favouriteTopics"] == nil) {
            [storage setObject:[NSMutableArray new] forKey:@"favouriteTopics"];
        }
        [storage synchronize];
    }
    return storage;
}
@end
