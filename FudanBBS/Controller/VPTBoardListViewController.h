//
//  VPTBoardViewController.h
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPTNetworkService.h"

@interface VPTBoardListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
enum BoardListViewType {
    BoardListViewTypeAllSections,
    BoardListViewTypeRecommandedBoardsForSection,
    BoardListViewTypeAllBoardsForSection,
    BoardListViewTypeSubdirectoryForSection,
    BoardListViewTypeAllFavouriteBoards
};

@property (nonatomic) enum BoardListViewType boardListViewType;

@end
