//
//  VPTBoardViewController.m
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Masonry/Masonry.h"
#import "Ono.h"

#import "FlatUIKit.h"
#import "VPTBoardListViewController.h"
#import "VPTTopicListViewController.h"
#import "VPTServiceManager.h"
#import "VPTSimpleCell.h"

@interface VPTBoardListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *boardDesc;
@property (nonatomic, strong) NSString *sectionId;
@property (nonatomic, strong) NSString *sectionDesc;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation VPTBoardListViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        _boardListViewType = BoardListViewTypeAllSections;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id callback = ^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSource = result;
            [_tableView reloadData];
        });
    };
    if (_boardListViewType == BoardListViewTypeAllSections) {
        [VPTServiceManager fetchAllBoardSectionsWithcompletionHandler:callback];
    } else if (_boardListViewType == BoardListViewTypeAllBoardsForSection) {
        [VPTServiceManager fetchBoardListWithSection:_sectionId completionHandler:callback];
    } else if (_boardListViewType == BoardListViewTypeSubdirectoryForSection) {
        [VPTServiceManager fetchSubdirectoryWithBoard:_boardId completionHandler:callback];
    } else if (_boardListViewType == BoardListViewTypeAllFavouriteBoards) {
        _dataSource = [[NSMutableArray alloc] initWithArray:[VPTServiceManager getFavouriteBoardList]];
    }
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[VPTSimpleCell class] forCellReuseIdentifier:@"VPTSimpleCell"];
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    [_tableView setContentInset:adjustForTabbarInsets];
    [_tableView setScrollIndicatorInsets:adjustForTabbarInsets];

    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_tableView) {
        if (_boardListViewType == BoardListViewTypeAllFavouriteBoards) {
            _dataSource = [[NSMutableArray alloc] initWithArray:[VPTServiceManager getFavouriteBoardList]];
            [_tableView reloadData];
        }
    }
    if (_boardListViewType == BoardListViewTypeAllSections) {
        [self.tabBarController setTitle:@"所有板块"];
    } else if (_boardListViewType == BoardListViewTypeRecommandedBoardsForSection){
        [self.navigationItem setTitle:_sectionDesc];
    } else if (_boardListViewType == BoardListViewTypeAllBoardsForSection) {
        [self.navigationItem setTitle:_sectionDesc];
    } else if (_boardListViewType == BoardListViewTypeAllFavouriteBoards) {
        [self.navigationItem setTitle:@"我收藏的板块"];
    } else if (_boardListViewType == BoardListViewTypeSubdirectoryForSection) {
        [self.navigationItem setTitle:_boardDesc];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VPTSimpleCell *cell = (VPTSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"VPTSimpleCell"];
    id cellInfo = _dataSource[indexPath.row];
    if (_boardListViewType == BoardListViewTypeAllFavouriteBoards) {
        cell.title = [VPTServiceManager getAllBoardDictionary][cellInfo[@"boardId"]][@"desc"];
    } else if (_boardListViewType == BoardListViewTypeAllSections) {
        cell.title = cellInfo[@"section"][@"desc"];
        cell.type = VPTSimpleCellFolder;
    } else {
        cell.title = cellInfo[@"desc"];
        if (cellInfo[@"cate"]) {
            cell.detail = cellInfo[@"cate"];
        }
        if ([cellInfo[@"dir"] isEqualToString:@"1"]) {
            cell.type = VPTSimpleCellFolder;
        } else {
            cell.type = VPTSimpleCellBoard;
        }
    }
//    if (_boardListViewType == BoardListViewTypeRecommandedBoardsForSection && indexPath.row == 0) {
//        [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor cloudsColor] roundingCorners:UIRectCornerAllCorners];
//    } else {
//        [cell configureFlatCellWithColor:[UIColor peterRiverColor] selectedColor:[UIColor cloudsColor] roundingCorners:UIRectCornerAllCorners];
//    }
    [cell setNeedsUpdateConstraints];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id cellInfo = _dataSource[indexPath.row];
    [cell setSelected:NO];
    if (_boardListViewType ==BoardListViewTypeAllFavouriteBoards) {
        NSDictionary *cellInfo = [VPTServiceManager getAllBoardDictionary][cellInfo[@"boardId"]];
        VPTTopicListViewController *tlvc = [VPTTopicListViewController new];
        [tlvc setBoardId:cellInfo[@"title"]];
        [tlvc setBoardName:cellInfo[@"desc"]];
        [self.navigationController pushViewController:tlvc animated:YES];
    } if (_boardListViewType == BoardListViewTypeAllSections) {
        VPTBoardListViewController *bvc = [VPTBoardListViewController new];
        [bvc setDataSource:cellInfo[@"boards"]];
        [bvc setSectionId:cellInfo[@"section"][@"id"]];
        [bvc setSectionDesc:cellInfo[@"section"][@"desc"]];
        [bvc setBoardListViewType:BoardListViewTypeRecommandedBoardsForSection];
        [self.navigationController pushViewController:bvc animated:YES];
    } else if (_boardListViewType == BoardListViewTypeRecommandedBoardsForSection) {
        if (indexPath.row == 0) {
            VPTBoardListViewController *bvc = [VPTBoardListViewController new];
            [bvc setSectionId:_sectionId];
            [bvc setSectionDesc:_sectionDesc];
            [bvc setBoardListViewType:BoardListViewTypeAllBoardsForSection];
            [self.navigationController pushViewController:bvc animated:YES];
        } else {
            VPTTopicListViewController *tlvc = [VPTTopicListViewController new];
            [tlvc setBoardName:cellInfo[@"desc"]];
            [tlvc setBoardId:cellInfo[@"name"]];
            [self.navigationController pushViewController:tlvc animated:YES];
        }
    } else if (_boardListViewType == BoardListViewTypeAllBoardsForSection || _boardListViewType == BoardListViewTypeSubdirectoryForSection){
        if ([cellInfo[@"dir"] isEqualToString:@"1"]) {
            VPTBoardListViewController *bvc = [VPTBoardListViewController new];
            [bvc setBoardListViewType:BoardListViewTypeSubdirectoryForSection];
            [bvc setBoardId:cellInfo[@"title"]];
            [bvc setBoardDesc:cellInfo[@"desc"]];
            [self.navigationController pushViewController:bvc animated:YES];
        } else {
            VPTTopicListViewController *tlvc = [VPTTopicListViewController new];
            [tlvc setBoardId:cellInfo[@"title"]];
            [tlvc setBoardName:cellInfo[@"desc"]];
            [self.navigationController pushViewController:tlvc animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

@end
