//
//  VPTopicListViewController.m
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Masonry/Masonry.h"
#import "Ono.h"

#import "VPTTopicListViewController.h"
#import "VPTTopicViewController.h"
#import "VPTDataManager.h"

@interface VPTTopicListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *topicArray;
@property (nonatomic, strong) UIButton *prevPage;
@property (nonatomic, strong) UIButton *nextPage;
@property (nonatomic, strong) UIView *footerView;
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
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        _footerView = [self tableFooterView];
        [_tableView setTableFooterView:_footerView];
        [NetworkService request:[self urlForBoard:_boardId] delegate:self];
    } else if (_topicListViewType == VPTTopicListViewTypeDataFromFavourite) {
        _topicArray = [[NSMutableArray alloc] initWithArray:[VPTDataManager getFavouriteTopicList]];
    }

    [self.view addSubview:_tableView];
    [self updateViewConstraints];
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
    
    NSDictionary *normal = [NSDictionary dictionaryWithObjects:[[NSArray alloc] initWithObjects:[UIFont systemFontOfSize:14], [UIColor blueColor], nil]
                                                       forKeys:[[NSArray alloc] initWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil]];
    NSDictionary *disabled = [NSDictionary dictionaryWithObjects:[[NSArray alloc] initWithObjects:[UIFont systemFontOfSize:14], [UIColor grayColor], nil]
                                                         forKeys:[[NSArray alloc] initWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil]];
    
    _prevPage = [[UIButton alloc] init];
    _nextPage = [[UIButton alloc] init];
    
    [_prevPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"上一页" attributes:normal] forState:UIControlStateNormal];
    [_nextPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下一页" attributes:normal] forState:UIControlStateNormal];
    
    [_prevPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"上一页" attributes:disabled] forState:UIControlStateDisabled];
    [_nextPage setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下一页" attributes:disabled] forState:UIControlStateDisabled];
    
    [_prevPage setBackgroundColor:[UIColor grayColor]];
    [_nextPage setBackgroundColor:[UIColor grayColor]];
    
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
    [NetworkService request:[self urlForPrevPageWithBoard:_boardId start:_boardStart - 20] delegate:self];
}

- (void)goToNextPage {
    [NetworkService request:[self urlForNextPageWithBoard:_boardId start:_boardStart + 20] delegate:self];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TOPTenCell"];
    NSDictionary *topic = [_topicArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[topic objectForKey:@"title"]];
    
    if (_topicListViewType == VPTTopicListViewTypeDataFromBoard) {
        [cell.detailTextLabel setText:[topic objectForKey:@"board"]];
        if (topic[@"attributes"][@"sticky"] != nil) {
            [cell setBackgroundColor: [UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:0.5]];
        }
    } else if (_topicListViewType ==VPTTopicListViewTypeDataFromFavourite) {
        [cell.detailTextLabel setText:[topic objectForKey:@"boardName"]];
    }
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
    [_nextPage setEnabled:_boardStart + 20 <= _boardTotal];
    [_prevPage setEnabled:_boardStart > 0];
    [_footerView setHidden:!([_nextPage isEnabled] || [_prevPage isEnabled])];
    [_tableView reloadData];
}



@end
