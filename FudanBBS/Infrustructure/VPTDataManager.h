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
+ (BOOL)AddToFavouriteTopicListWithBoardName:(NSString *)boardName boardId:_boardId topicId:(NSString *)topicId title:(NSString *)title;
@end
