//
//  VPTServiceManager.m
//  FudanBBS
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTServiceManager.h"

@interface VPTServiceManager()
@end

@implementation VPTServiceManager

static NSDictionary *boardDictionary;
static NSArray *boardArray;

#pragma mark favourite topics

+ (NSArray *)getFavouriteTopicList {
    return [[self defaultStorage] objectForKey:@"favouriteTopics"];
}

+ (BOOL)isFavouriteTopicWithBoardId:(NSString *)boardId topicId:(NSString *)topicId {
    NSUserDefaults *storage = [self defaultStorage];
    NSArray *favouriteList = [storage objectForKey:@"favouriteTopics"];
    __block BOOL isFound = NO;
    [favouriteList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([boardId isEqualToString: obj[@"boardId"]] && [topicId isEqualToString:obj[@"id"]]) {
            isFound = YES;
            *stop = YES;
        }
    }];
    return isFound;
}

+ (BOOL)addToFavouriteTopicListWithBoardName:(NSString *)boardName boardId:(NSString *)boardId topicId:(NSString *)topicId title:(NSString *)title {
    if ([VPTServiceManager isFavouriteTopicWithBoardId:boardId topicId:topicId]) {
        return YES;
    }
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *favouriteList = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteTopics"]];
    [favouriteList addObject:@ {
        @"boardId": boardId,
        @"id": topicId,
        @"title": title,
    }];
    [storage setObject:favouriteList forKey:@"favouriteTopics"];
    [storage synchronize];
    return YES;
}

+ (BOOL)removeFromFavouriteTopicListWithBoardName:(NSString *)boardName boardId:(NSString *)boardId topicId:(NSString *)topicId {
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *favouriteList = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteTopics"]];
    __block BOOL isFound = NO;
    __block NSUInteger index = -1;
    [favouriteList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([boardId isEqualToString: obj[@"boardId"]] && [topicId isEqualToString:obj[@"id"]]) {
            isFound = YES;
            index = idx;
            *stop = YES;
        }
    }];
    if (isFound) {
        [favouriteList removeObjectAtIndex:index];
        [storage setObject:favouriteList forKey:@"favouriteTopics"];
        [storage synchronize];
    }
    return YES;
}

#pragma mark favourite boards

+ (NSArray *)getFavouriteBoardList {
    return [[self defaultStorage] objectForKey:@"favouriteBoards"];
}

+ (BOOL)isFavouriteBoardWithBoardId:(NSString *)boardId {
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *favouriteList = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteBoards"]];
    __block BOOL isFound = NO;
    [favouriteList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([boardId isEqualToString:obj[@"boardId"]]) {
            isFound = YES;
            *stop = YES;
        }
    }];
    return isFound;
}


+ (BOOL)addToFavouriteBoardListWithBoardId:(NSString *)boardId {
    if ([self isFavouriteBoardWithBoardId:boardId]) {
        return YES;
    }
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *favouriteList = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteBoards"]];
    [favouriteList addObject:@ {
        @"boardId": boardId
    }];
    [storage setObject:favouriteList forKey:@"favouriteBoards"];
    [storage synchronize];
    return YES;
}

+ (BOOL)removeFromFavouriteBoardListWithBoardId:(NSString *)boardId {
    NSUserDefaults *storage = [self defaultStorage];
    NSMutableArray *favouriteList = [[NSMutableArray alloc] initWithArray:[storage objectForKey:@"favouriteBoards"]];
    __block BOOL isFound = NO;
    __block NSUInteger index = -1;
    [favouriteList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([boardId isEqualToString:obj[@"boardId"]]) {
            isFound = YES;
            index = idx;
            *stop = YES;
        }
    }];
    if (isFound) {
        [favouriteList removeObjectAtIndex:index];
        [storage setObject:favouriteList forKey:@"favouriteBoards"];
        [storage synchronize];
    }
    return YES;
}

#pragma mark all boards related

+ (NSArray *)getAllBoardList {
    if (boardArray == nil) {
        boardArray = [[self defaultStorage] objectForKey:@"boardArray"];
    }
    return boardArray;
}

+ (NSDictionary *)getAllBoardDictionary {
    if (boardDictionary == nil) {
        boardDictionary = [[self defaultStorage] objectForKey:@"boardDictionary"];
    }
    return boardDictionary;
}

+ (BOOL)setAllBoardDictionary:(NSDictionary *)boardDictionary {
    NSUserDefaults *storage = [self defaultStorage];
    [storage setObject:boardDictionary forKey:@"boardDictionary"];
    [storage synchronize];
    return YES;
}

+ (BOOL)setAllBoardList:(NSArray *)boardList {
    NSUserDefaults *storage = [self defaultStorage];
    [storage setObject:boardList forKey:@"boardList"];
    [storage synchronize];
    return YES;
}


+ (NSDictionary *)getUserInformation {
    return [[self defaultStorage] objectForKey:@"userInformation"];
}

+ (BOOL)setUserInformation:(NSDictionary *)userInformation {
    NSUserDefaults *storage = [self defaultStorage];
    [storage setObject:userInformation forKey:@"userInformation"];
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
        if ([storage objectForKey:@"favouriteBoards"] == nil) {
            [storage setObject:[NSMutableArray new] forKey:@"favouriteBoards"];
        }
        if ([storage objectForKey:@"userInformation"] == nil) {
            [storage setObject:[NSMutableDictionary new] forKey:@"userInformation"];
        }
        [storage synchronize];
    }
    return storage;
}

@end
