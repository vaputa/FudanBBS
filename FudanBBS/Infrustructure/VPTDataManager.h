//
//  VPTDataManager.h
//  FudanBBS
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPTDataManager : NSObject

+ (NSArray *)getFavouriteTopicList;
+ (BOOL)addToFavouriteTopicListWithBoardName:(NSString *)boardName boardId:(NSString *)_boardId topicId:(NSString *)topicId title:(NSString *)title;
+ (BOOL)removeFromFavouriteTopicListWithBoardName:(NSString *)boardName boardId:(NSString *)boardId topicId:(NSString *)topicId;
+ (BOOL)isFavouriteTopicWithBoardId:(NSString *)boardId topicId:(NSString *)topicId;

+ (NSArray *)getFavouriteBoardList;
+ (BOOL)addToFavouriteBoardListWithBoardId:(NSString *)boardId;
+ (BOOL)removeFromFavouriteBoardListWithBoardId:(NSString *)boardId;
+ (BOOL)isFavouriteBoardWithBoardId:(NSString *)boardId;

+ (NSArray *)getAllBoardList;
+ (NSDictionary *)getAllBoardDictionary;
+ (BOOL)setAllBoardList:(NSArray *)boardList;
+ (BOOL)setAllBoardDictionary:(NSDictionary *)boardDictionary;

@end
