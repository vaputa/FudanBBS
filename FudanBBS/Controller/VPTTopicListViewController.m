//
//  VPTopicListViewController.m
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <NSDate_TimeAgo/NSDate+TimeAgo.h>
#import <Ono/Ono.h>
#import "FlatUIKit.h"

#import "VPTTopicListViewController.h"
#import "VPTTopicViewController.h"
#import "VPTServiceManager.h"
#import "VPTSimpleCell.h"
#import "VPTUtil.h"

@interface VPTTopicListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FUIButton *prevPage;
@property (nonatomic, strong) FUIButton *nextPage;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *btnFavourite;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) BOOL isFavourite;
@end

@implementation VPTTopicListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _boardStart = -1l;
        _boardTotal = -1l;
        _topicListViewType = VPTTopicListViewTypeDataFromBoard;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[VPTSimpleCell class] forCellReuseIdentifier:@"VPTSimpleCell"];
    
    _tableView.bounces = NO;
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        _footerView = [self tableFooterView];
        [_footerView setHidden:YES];
        [_tableView setTableFooterView:_footerView];
        [VPTServiceManager fetchTopicWithBoard:_boardId start:0 completionHandler:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTableData:result];
            });
        }];
    } else if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        _dataSource = [VPTServiceManager getFavouriteTopicList];
    }
    [self.view addSubview:_tableView];
    
    _isFavourite = [VPTServiceManager isFavouriteBoardWithBoardId:_boardId];
    _btnFavourite = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_btnFavourite setBackgroundImage:[UIImage imageNamed:_isFavourite ? @"icon_favourite" : @"icon_unfavourite"] forState:UIControlStateNormal];
    [_btnFavourite addTarget:self action:@selector(toggleFavourite) forControlEvents:UIControlEventTouchUpInside];
    
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:_btnFavourite]];
    }
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:_boardName];
    if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        _dataSource = [VPTServiceManager getFavouriteTopicList];
        [_tableView reloadData];
    }
}

- (void)toggleFavourite {
    if (_isFavourite) {
        [VPTServiceManager removeFromFavouriteBoardListWithBoardId:_boardId];
    } else {
        [VPTServiceManager addToFavouriteBoardListWithBoardId:_boardId];
    }
    _isFavourite = !_isFavourite;
    [_btnFavourite setBackgroundImage:[UIImage imageNamed:_isFavourite ? @"icon_favourite" : @"icon_unfavourite"] forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
}

- (UIView *)tableFooterView {
    if (_footerView) {
        return _footerView;
    }
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60)];
    
    _prevPage = [[FUIButton alloc] init];
    _nextPage = [[FUIButton alloc] init];
    
    _prevPage.buttonColor = [UIColor turquoiseColor];
    _prevPage.shadowColor = [UIColor greenSeaColor];
    _prevPage.shadowHeight = 3.0f;
    _prevPage.cornerRadius = 6.0f;
    _prevPage.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_prevPage setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_prevPage setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [_prevPage setTitle:@"上一页" forState:UIControlStateNormal];
    [_nextPage setTitle:@"下一页" forState:UIControlStateNormal];
    
    _nextPage.buttonColor = [UIColor turquoiseColor];
    _nextPage.shadowColor = [UIColor greenSeaColor];
    _nextPage.shadowHeight = 3.0f;
    _nextPage.cornerRadius = 6.0f;
    _nextPage.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [_nextPage setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_nextPage setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [_prevPage addTarget:self action:@selector(goToPrevPage) forControlEvents:UIControlEventTouchUpInside];
    [_nextPage addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView addSubview:_prevPage];
    [_footerView addSubview:_nextPage];
    
    [_prevPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerView).multipliedBy(0.3);
        make.height.equalTo(_footerView).offset(-20);
        make.right.equalTo(_footerView.mas_centerX).offset(-30);
        make.centerY.equalTo(_footerView);
    }];
    [_nextPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerView).multipliedBy(0.3);
        make.height.equalTo(_footerView).offset(-20);
        make.left.equalTo(_footerView.mas_centerX).offset(30);
        make.centerY.equalTo(_footerView);
    }];
    return _footerView;
}

- (void)goToPrevPage {
    [VPTServiceManager fetchTopicWithBoard:_boardId start:(_boardStart - 20 <= 0 ? 1 : _boardStart - 20) completionHandler:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableData:result];
        });
    }];
}

- (void)goToNextPage {
    [VPTServiceManager fetchTopicWithBoard:_boardId start:_boardStart + 20 completionHandler:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableData:result];
        });
    }];
}

- (void)reloadTableData:(NSDictionary *)result {
    _dataSource = result[@"dataSource"];
    _boardStart = [result[@"start"] integerValue];
    _boardTotal = [result[@"total"] integerValue];
    [_nextPage setHidden:!(_boardStart + 20 <= _boardTotal)];
    [_prevPage setHidden:!(_boardStart > 0)];
    [_footerView setHidden:!([_nextPage isEnabled] || [_prevPage isEnabled])];
    [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top)];
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    VPTSimpleCell *cell = (VPTSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"VPTSimpleCell"];
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    cell.title = [cellInfo objectForKey:@"title"];
    
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        cell.detail = [[VPTUtil dateFromStandardString:cellInfo[@"attributes"][@"time"]] timeAgo];
        if (cellInfo[@"attributes"][@"sticky"] != nil) {
            cell.type = VPTSimpleCellTop;
        } else {
            cell.type = VPTSimpleCellTopic;
        }
    } else if (_topicListViewType ==VPTTopicListViewTypeDataFromFavourite) {
        cell.detail = [VPTServiceManager getAllBoardDictionary][cellInfo[@"boardId"]][@"desc"];
        cell.type = VPTSimpleCellFavourite;
    }
    [cell setNeedsUpdateConstraints];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *cellInfo = _dataSource[indexPath.row];
    [cell setSelected:NO];
    VPTTopicViewController *tvc = [[VPTTopicViewController alloc] init];
    [tvc setGid:cellInfo[@"id"]];
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        [tvc setBoardName:_boardName];
        [tvc setBoardId:_boardId];
    } else if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        [tvc setBoardId:cellInfo[@"boardId"]];
        [tvc setBoardName:cellInfo[@"boardName"]];
    }
    [tvc setPostTitle:cellInfo[@"title"]];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

@end
