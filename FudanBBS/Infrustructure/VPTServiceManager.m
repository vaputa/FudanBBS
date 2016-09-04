//
//  VPTServiceManager.m
//  FudanBBS
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTServiceManager.h"
#import "VPTTopic.h"
#import "VPTPost.h"
#import "VPTUtil.h"

#import <Ono/Ono.h>

@interface VPTServiceManager()
@end

@implementation VPTServiceManager

static NSDictionary *cacheBoardDictionary;
static NSArray *cacheBoardArray;

#pragma mark favourite topics

+ (BOOL)isLogin {
    return [[VPTServiceManager getUserInformation] count] > 0;
}

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
        if ([boardId isEqualToString:obj[@"boardId"]] && [topicId isEqualToString:obj[@"id"]]) {
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
    return [[[self defaultStorage] objectForKey:@"favouriteBoards"] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [VPTServiceManager getAllBoardDictionary][evaluatedObject[@"boardId"]][@"desc"] != nil;
    }]];
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
    if (cacheBoardArray == nil) {
        cacheBoardArray = [[self defaultStorage] objectForKey:@"boardArray"];
    }
    return cacheBoardArray;
}

+ (NSDictionary *)getAllBoardDictionary {
    if (cacheBoardDictionary == nil) {
        cacheBoardDictionary = [[self defaultStorage] objectForKey:@"boardDictionary"];
    }
    return cacheBoardDictionary;
}

+ (BOOL)setAllBoardDictionary:(NSDictionary *)boardDictionary {
    NSUserDefaults *storage = [self defaultStorage];
    cacheBoardDictionary = boardDictionary;
    [storage setObject:boardDictionary forKey:@"boardDictionary"];
    [storage synchronize];
    return YES;
}

+ (BOOL)setAllBoardList:(NSArray *)boardList {
    NSUserDefaults *storage = [self defaultStorage];
    cacheBoardArray = boardList;
    [storage setObject:boardList forKey:@"boardList"];
    [storage synchronize];
    return YES;
}


+ (NSDictionary *)getUserInformation {
    return [[self defaultStorage] objectForKey:@"userInformation"];
}

+ (BOOL)clearUserInformation {
    [[self defaultStorage] removeObjectForKey:@"userInformation"];
    [[self defaultStorage] synchronize];
    return YES;
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

+ (void)replyWithTitle:(NSString *)title
               boardId:(NSString *)boardId
                 topic:(NSString *)topicId
                  text:(NSString *)text
     completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSString *url = [[NSString alloc] initWithFormat:@"https://bbs.fudan.edu.cn/bbs/snd?board=%@&f=%@&utf8=1", boardId, topicId];
    NSDictionary *data = @{@"title":title, @"sig":@"1", @"text":text};
    [VPTNetworkService requestWithUrlString:url method:@"POST" data:data completionHandler:^(NSString *response, NSError *error) {
        completionHandler(response, error);
    }];
}


#pragma mark login/logout service
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^_Nullable)(NSDictionary *))success
                  failure:(void (^_Nullable)(NSDictionary *))failure {
    [VPTNetworkService requestWithUrlString:@"https://bbs.fudan.edu.cn/bbs/login" method:@"POST"
                                       data:@{
                                              @"id": username,
                                              @"pw": password,
                                              @"persistent": @"on"
                                              }
                          completionHandler:^(NSString *response, NSError *error) {
                              if (!error) {
                                  if ([response hasPrefix:@"<html>"] || response == nil) {
                                      failure(@{@"code":@"403", @"error": @"用户名和密码不匹配"});
                                  } else {
                                      response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
                                      ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
                                      NSString *nickname = [[[[[[document rootElement] childrenWithTag:@"session"] firstObject] childrenWithTag:@"u"] firstObject] stringValue];
                                      NSDictionary *userInformation = @{@"username": nickname };
                                      [VPTServiceManager setUserInformation:userInformation];
                                      success(userInformation);
                                  }
                              } else {
                                  failure(@{@"code":@"404", @"error": @"网络无法连接"});
                              }
                          }];
}
+ (void)logout {
    [VPTNetworkService requestWithUrlString:@"http://bbs.fudan.edu.cn/bbs/logout" method:@"GET" data:nil completionHandler:nil];
}

#pragma mark fetch data

+ (void)fetchAllBoards {
    [VPTNetworkService requestWithUrlString:@"http://bbs.fudan.edu.cn/bbs/all" method:@"GET" data:nil completionHandler:^(NSString *response, NSError *error) {
        if (error != nil)
            return ;
        response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
        NSMutableArray *boardArray = [NSMutableArray new];
        NSMutableDictionary *boardDictionary = [NSMutableDictionary new];
        for (ONOXMLElement *board in [document.rootElement childrenWithTag:@"brd"]){
            [boardArray addObject:[board attributes]];
            [boardDictionary setObject:[board attributes] forKey:[board attributes][@"title"]];
        }
        [VPTServiceManager setAllBoardDictionary:boardDictionary];
        [VPTServiceManager setAllBoardList:boardArray];
    }];
}

+ (void)fetchTopTenDataWithCompletionHandler:(void (^)(id result, NSError *error))completionHandler {
    [VPTNetworkService requestWithUrlString:@"https://bbs.fudan.edu.cn/bbs/top10" method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            NSString *data = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            NSMutableArray *result = [NSMutableArray new];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            for (ONOXMLElement *element in [document.rootElement children]){
                if ([@"top" isEqualToString:[element tag]]){
                    VPTTopic *topic = [VPTTopic new];
                    topic.title = [[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    topic.board = [element attributes][@"board"];
                    topic.owner = [element attributes][@"owner"];
                    topic.gid = [element attributes][@"gid"];
                    topic.count = [element attributes][@"count"];
                    [result addObject:topic];
                }
            }
            completionHandler(result, nil);
        } else {
            completionHandler(nil, error);
        }
    }];
}

+ (void)fetchPostWithBoardId:(NSString *)boardId gid:(NSString *)gid fid:(NSString *)fid type:(NSInteger)type completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSString *url = nil;
    switch (type) {
        case 0:
            url = [NSString stringWithFormat:@"https://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&f=%@", boardId, gid];
            break;
        case 1:
            url = [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&g=%@&f=%@&a=p", boardId, gid, fid];
            break;
        case 2:
            url = [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&g=%@&f=%@&a=n", boardId, gid, fid];
            break;
        default:
            break;
    }
    [VPTNetworkService requestWithUrlString:url method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            NSMutableArray *posts = [[NSMutableArray alloc] init];
            for (ONOXMLElement *child in [[document rootElement] children]){
                if ([[child tag] isEqualToString:@"po"]) {
                    VPTPost *post = [VPTPost new];
                    post.nick = [[[child childrenWithTag:@"nick"] firstObject] stringValue];
                    post.owner = [[[child childrenWithTag:@"owner"] firstObject] stringValue];
                    post.date = [VPTUtil dateFromString:[[[child childrenWithTag:@"date"] firstObject] stringValue]];
                    post.title = [[[child childrenWithTag:@"title"] firstObject] stringValue];
                    post.board = [[[child childrenWithTag:@"board"] firstObject] stringValue];
                    NSMutableArray *content = [NSMutableArray new];
                    NSString *reply = @"";
                    for (ONOXMLElement *pa in [child childrenWithTag:@"pa"]) {
                        if ([[[pa attributes] objectForKey:@"m"] isEqualToString:@"t"]) {
                            for (ONOXMLElement *p in [pa childrenWithTag:@"p"]) {
                                if (![[[p stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                                    [content addObject:@{
                                                         @"type": @"text",
                                                         @"text": [p stringValue]
                                                         }];
                                }
                                for (ONOXMLElement *a in [p childrenWithTag:@"a"]) {
                                    if ([[a attributes][@"href"] hasPrefix:@"http://bbs.fudan.edu.cn/upload/"]) {
                                        [content addObject:@{
                                                             @"type": @"image",
                                                             @"href": [a attributes][@"href"]
                                                             }];
                                    } else {
                                        [content addObject:@{
                                                             @"type": @"text",
                                                             @"text": [a attributes][@"href"]
                                                             }];
                                    }
                                }
                            }
                        } else if ([[[pa attributes] objectForKey:@"m"] isEqualToString:@"q"]) {
                            for (ONOXMLElement *p in [pa children]){
                                if ([[p tag] isEqualToString:@"p"]) {
                                    reply = [reply stringByAppendingFormat:@"%@\n", [p stringValue]];
                                }
                            }
                        }
                    }
                    post.content = content;
                    post.reply = reply;
                    post.attributes = [child attributes];
                    [posts addObject:post];
                }
            }
            completionHandler(posts, nil);
        } else {
            completionHandler(nil, error);
        }
    }];
}

+ (void)fetchBoardListWithSection:(NSString *)section completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSString *url = [NSString stringWithFormat:@"https://bbs.fudan.edu.cn/bbs/boa?s=%@", section];
    [VPTNetworkService requestWithUrlString:url method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (ONOXMLElement *boardEle in [[document rootElement] children]){
                if ([[boardEle tag] isEqualToString:@"brd"]) {
                    [result addObject:[boardEle attributes]];
                }
            }
            [result sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return -[[obj1 objectForKey:@"dir"] compare:[obj2 objectForKey:@"dir"]];
            }];
            completionHandler(result, error);
        } else {
            completionHandler(nil, error);
        }
    }];
}

+ (void)fetchSubdirectoryWithBoard:(NSString *)board completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSString *url = [NSString stringWithFormat:@"https://bbs.fudan.edu.cn/bbs/boa?board=%@", board];
   [VPTNetworkService requestWithUrlString:url method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (ONOXMLElement *boardEle in [[document rootElement] children]){
                if ([[boardEle tag] isEqualToString:@"brd"]) {
                    [result addObject:[boardEle attributes]];
                }
            }
            [result sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return -[[obj1 objectForKey:@"dir"] compare:[obj2 objectForKey:@"dir"]];
            }];
            completionHandler(result, error);
        } else {
            completionHandler(nil, error);
        }
    }];
}


+ (void)fetchAllBoardSectionsWithcompletionHandler:(void (^)(id result, NSError *error))completionHandler {
    [VPTNetworkService requestWithUrlString:@"https://bbs.fudan.edu.cn/bbs/sec" method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (ONOXMLElement *sectionEle in [[document rootElement] children]){
                if ([[sectionEle tag] isEqualToString:@"sec"]) {
                    NSMutableDictionary *section = [NSMutableDictionary new];
                    [section setObject:[sectionEle attributes] forKey:@"section"];
                    [section setObject:[NSMutableArray new] forKey:@"boards"];
                    for (ONOXMLElement *boardEle in [sectionEle children]) {
                        [[section objectForKey:@"boards"] addObject:[boardEle attributes]];
                    }
                    [[section objectForKey:@"boards"] insertObject:@{@"desc":@"所有子版块"} atIndex:0];
                    [result addObject:section];
                }
            }
            completionHandler(result, nil);
        } else {
            completionHandler(nil, error);
        }
    }];
}

+ (void)fetchTopicWithBoard:(NSString *)board start:(NSUInteger)start completionHandler:(void (^)(id result, NSError *error))completionHandler {
    NSString *url = nil;
    if (start) {
        url = [NSString stringWithFormat:@"https://bbs.fudan.edu.cn/bbs/tdoc?new=1&board=%@&start=%lu", board, (unsigned long)start];
    } else {
        url = [NSString stringWithFormat:@"https://bbs.fudan.edu.cn/bbs/tdoc?board=%@", board];
    }
    [VPTNetworkService requestWithUrlString:url method:@"GET" completionHandler:^(NSString *response, NSError *error) {
        if (!error) {
            response = [response stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
            ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[response dataUsingEncoding:NSUTF8StringEncoding] error:nil];
            NSMutableDictionary *result = [NSMutableDictionary new];
            NSMutableArray *dataSource = [NSMutableArray new];
            for (ONOXMLElement *topic in [document.rootElement children]){
                if ([[topic tag] isEqualToString:@"po"]){
                    [dataSource insertObject:@{
                                                @"title":[topic stringValue],
                                                @"id":[[topic attributes] objectForKey:@"id"],
                                                @"attributes":[topic attributes]
                                                }
                                      atIndex:0
                     ];
                } else if ([[topic tag] isEqualToString:@"brd"]){
                    result[@"total"] = [topic attributes][@"total"];
                    result[@"start"] = [topic attributes][@"start"];
                }
            }
            result[@"dataSource"] = dataSource;
            completionHandler(result, nil);
        } else {
            completionHandler(nil, error);
        }
    }];
}

@end
