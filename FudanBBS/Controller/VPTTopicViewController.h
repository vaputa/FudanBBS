//
//  VPTTopicViewController.h
//  FudanBBS
//
//  Created by leon on 3/2/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPTNetworkService.h"

@interface VPTTopicViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, strong) NSString *postTitle;
@end
