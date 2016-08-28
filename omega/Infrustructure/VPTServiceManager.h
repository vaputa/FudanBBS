//
//  VPTServiceManager.h
//  FudanBBS
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VPTNetworkService.h"

@interface VPTServiceManager : NSObject

+ (NSArray *)getFavouriteTopicList;
+ (BOOL)addToFavouriteTopicListWithBoardName:(NSString *)boardName boardId:(NSString *)boardId topicId:(NSString *)topicId title:(NSString *)title;
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

+ (NSDictionary *)getUserInformation;
+ (BOOL)clearUserInformation;
+ (BOOL)setUserInformation:(NSDictionary *)userInformation;


+ (BOOL)replyWithTitle:(NSString *)title boardId:(NSString *)boardId topic:(NSString *)topicId text:(NSString *)text;

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSDictionary *))failure;
+ (void)logout;

+ (void)fetchTopTenDataWithCompletionHandler:(void (^)(id result, NSError *error))completionHandler;
+ (void)fetchPostWithBoardId:(NSString *)boardId gid:(NSString *)gid fid:(NSString *)fid type:(NSInteger)type completionHandler:(void (^)(id result, NSError *error))completionHandler;
+ (void)fetchBoardListWithSection:(NSString *)section completionHandler:(void (^)(id result, NSError *error))completionHandler;
+ (void)fetchSubdirectoryWithBoard:(NSString *)board completionHandler:(void (^)(id result, NSError *error))completionHandler;
+ (void)fetchAllBoardSectionsWithcompletionHandler:(void (^)(id result, NSError *error))completionHandler;
@end
