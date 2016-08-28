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

#import "VPTTopicListViewController.h"
#import "VPTTopicViewController.h"
#import "VPTServiceManager.h"
#import "VPTSimpleCell.h"
#import "VPTUtil.h"
@interface VPTTopicListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) UIButton *prevPage;
@property (nonatomic, strong) UIButton *nextPage;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *btnFavourite;
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
        [_tableView setTableFooterView:_footerView];
        [VPTNetworkService request:[self urlForBoard:_boardId] delegate:self];
    } else if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        _topicArray = [[NSMutableArray alloc] initWithArray:[VPTServiceManager getFavouriteTopicList]];
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
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    
    NSDictionary *normal = [NSDictionary dictionaryWithObjects:[[NSArray alloc] initWithObjects:[UIFont systemFontOfSize:14], [UIColor blackColor], nil]
                                                       forKeys:[[NSArray alloc] initWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil]];
    
    _prevPage = [[UIButton alloc] init];
    _nextPage = [[UIButton alloc] init];
    
    [_prevPage setImage:[UIImage imageNamed:@"icon_last"] forState:UIControlStateNormal];
    [_nextPage setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];

    [_prevPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"上一页" attributes:normal] forState:UIControlStateNormal];
    [_nextPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下一页" attributes:normal] forState:UIControlStateNormal];

    _nextPage.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _nextPage.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _nextPage.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    [_prevPage addTarget:self action:@selector(goToPrevPage) forControlEvents:UIControlEventTouchUpInside];
    [_nextPage addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView addSubview:_prevPage];
    [_footerView addSubview:_nextPage];
    
    [_prevPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerView).dividedBy(2.0);
        make.height.equalTo(_footerView);
        make.left.equalTo(_footerView);
        make.top.equalTo(_footerView);
    }];
    [_nextPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerView).dividedBy(2.0);
        make.height.equalTo(_footerView);
        make.right.equalTo(_footerView);
        make.top.equalTo(_footerView);
    }];
    return _footerView;
}

- (void)goToPrevPage {
    [VPTNetworkService request:[self urlForPrevPageWithBoard:_boardId start:_boardStart - 20] delegate:self];
}

- (void)goToNextPage {
    [VPTNetworkService request:[self urlForNextPageWithBoard:_boardId start:_boardStart + 20] delegate:self];
}

- (NSString *)urlForBoard:(NSString *)board {
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tdoc?board=%@", board];
}

- (NSString *)urlForPrevPageWithBoard:(NSString *)board start:(NSInteger)start{
    if (start <= 0) {
        start = 1;
    }
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tdoc?new=1&board=%@&start=%ld", board, (long)start];
}

- (NSString *)urlForNextPageWithBoard:(NSString *)board start:(NSInteger)start{
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tdoc?new=1&board=%@&start=%ld", board, (long)start];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    VPTSimpleCell *cell = (VPTSimpleCell *)[tableView dequeueReusableCellWithIdentifier:@"VPTSimpleCell"];
    NSDictionary *cellInfo = [_topicArray objectAtIndex:indexPath.row];
    cell.title = [cellInfo objectForKey:@"title"];
    
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        cell.detail = [[VPTUtil dateFromStandardString:cellInfo[@"attributes"][@"time"]] timeAgo];
        if (cellInfo[@"attributes"][@"sticky"] != nil) {
            cell.type = VPTSimpleCellTop;
        } else {
            cell.type = VPTSimpleCellTopic;
        }
    } else if (_topicListViewType ==VPTTopicListViewTypeDataFromFavourite) {
        NSString *boardId = [cellInfo objectForKey:@"boardId"];
        [cell.detailTextLabel setText:[VPTServiceManager getAllBoardDictionary][boardId][@"desc"]];
    }
    [cell setNeedsUpdateConstraints];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = [_topicArray objectAtIndex:indexPath.row];
    [cell setSelected:NO];
    VPTTopicViewController *tvc = [[VPTTopicViewController alloc] init];
    [tvc setGid:[dict objectForKey:@"id"]];
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        [tvc setBoardName:_boardName];
        [tvc setBoardId:_boardId];
    } else if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        [tvc setBoardId:[dict objectForKey:@"boardId"]];
        [tvc setBoardName:[dict objectForKey:@"boardName"]];
    }
    [tvc setPostTitle:[dict objectForKey:@"title"]];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_topicArray count];
}

- (void)receiveData:(NSString *)data{
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    _topicArray = [[NSMutableArray alloc] init];
    for (ONOXMLElement *topic in [document.rootElement children]){
        if ([[topic tag] isEqualToString:@"po"]){
            [_topicArray insertObject:@{
                                     @"title":[topic stringValue],
                                     @"id":[[topic attributes] objectForKey:@"id"],
                                     @"attributes":[topic attributes]
                                     }
                              atIndex:0
             ];
        } else if ([[topic tag] isEqualToString:@"brd"]){
            _boardTotal = [[topic attributes][@"total"] integerValue];
            _boardStart = [[topic attributes][@"start"] integerValue];
        }
    }
    [_nextPage setHidden:!(_boardStart + 20 <= _boardTotal)];
    [_prevPage setHidden:!(_boardStart > 0)];
    [_footerView setHidden:!([_nextPage isEnabled] || [_prevPage isEnabled])];
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top)];
}



@end
