//
//  VPTTopTenViewController.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <Ono/Ono.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FlatUIKit.h"

#import "VPTTopTenViewController.h"
#import "VPTTopicViewController.h"
#import "VPTServiceManager.h"
#import "VPTTopic.h"
#import "VPTTopTenTableViewCell.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface VPTTopTenViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation VPTTopTenViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[VPTTopTenTableViewCell class] forCellReuseIdentifier:@"TopTenCell"];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldFlatFontOfSize:18],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    [_tableView setContentInset:adjustForTabbarInsets];
    [_tableView setScrollIndicatorInsets:adjustForTabbarInsets];
    
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self updateViewConstraints];
    [VPTServiceManager fetchTopTenDataWithCompletionHandler:^(id result, NSError *error) {
        if (!error) {
            _dataSource = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        } else {
            
        }
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [VPTServiceManager fetchTopTenDataWithCompletionHandler:^(id result, NSError *error) {
        if (!error) {
            _dataSource = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        } else {
            
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"今日十大";
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopTenCell" forIndexPath:indexPath];
    [cell configureFlatCellWithColor:[UIColor greenSeaColor]
                       selectedColor:[UIColor cloudsColor]
                     roundingCorners:UIRectCornerAllCorners];
    cell.cornerRadius = 10.0f; // optional

    VPTTopic *topic = _dataSource[indexPath.row];
    cell.textLabel.text = topic.title;
    cell.detailTextLabel.text = [[VPTServiceManager getAllBoardDictionary] objectForKey:topic.board][@"desc"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = topic.count;
    label.layer.cornerRadius = 15;
    label.layer.borderColor = [UIColor turquoiseColor].CGColor;
    label.layer.borderWidth = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor cloudsColor];
    label.highlightedTextColor = [UIColor greenSeaColor];
    label.tag = -1;
    
    [cell.contentView addSubview:label];
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(15);
        make.top.equalTo(cell.contentView.mas_top).offset(5);
        make.right.equalTo(label.mas_left);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(label.mas_height);
        make.right.equalTo(cell.contentView).offset(-10);
        make.centerY.equalTo(cell.contentView);
    }];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    VPTTopic *topic = _dataSource[indexPath.row];
    VPTTopicViewController *tvc = [VPTTopicViewController new];
    [tvc setGid:topic.gid];
    [tvc setBoardId:topic.board];
    [tvc setPostTitle:topic.title];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
