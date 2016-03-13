//
//  VPTBoardViewController.h
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"

@interface VPTBoardListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataReceiveDelegate>
enum BoardListViewType {
    BoardListViewTypeAllSections,
    BoardListViewTypeRecommandedBoardsForSection,
    BoardListViewTypeAllBoardsForSection,
    BoardListViewTypeSubdirectoryForSection
};
@end
