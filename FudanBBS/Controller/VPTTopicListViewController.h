//
//  VPTopicListViewController.h
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPTNetworkService.h"

@interface VPTTopicListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) enum VPTTopicListViewType topicListViewType;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *boardCate;
@property (nonatomic, strong) NSString *boardMaster;
@property (nonatomic) NSInteger boardStart;
@property (nonatomic) NSInteger boardTotal;
enum VPTTopicListViewType {
    VPTTopicListViewTypeDataFromBoard,
    VPTTopicListViewTypeDataFromFavourite
};
@end
