//
//  VPTPersonalViewController.m
//  ;;
//
//  Created by leon on 3/13/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Masonry/Masonry.h"
#import "VPTPersonalViewController.h"
#import "VPTTopicListViewController.h"
#import "VPTBoardListViewController.h"
#import "VPTLoginViewController.h"
#import "VPTServiceManager.h"

@interface VPTPersonalViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic) BOOL isLogin;
@end

@implementation VPTPersonalViewController

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
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self updateDataSource];
    [self updateViewConstraints];
}

- (void)updateDataSource {
    if ([VPTServiceManager isLogin]) {
        _data = @[@"我收藏的板块", @"我收藏的帖子", @"登出"];
        _isLogin = 1;
    } else {
        _data = @[@"我收藏的板块", @"我收藏的帖子", @"登录"];
        _isLogin = 0;
    }
    [_tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"个人中心"];
    [self updateDataSource];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    switch (indexPath.row) {
        case 0: {
            VPTBoardListViewController *blvc = [VPTBoardListViewController new];
            [blvc setBoardListViewType:BoardListViewTypeAllFavouriteBoards];
            [self.navigationController pushViewController:blvc animated:YES];
            break;
        }
        case 1: {
            VPTTopicListViewController *tlvc = [VPTTopicListViewController new];
            [tlvc setTopicListViewType:VPTTopicListViewTypeDataFromFavourite];
            [self.navigationController pushViewController:tlvc animated:YES];
            break;
        }
        case 2: {
            if (!_isLogin) {
                VPTLoginViewController *lvc = [VPTLoginViewController new];
                [self.navigationController pushViewController:lvc animated:YES];
            } else {
                [self logout];
                [self updateDataSource];
            }
            break;
        }
        default:
            break;
    }
}

- (void)logout {
    [VPTServiceManager clearUserInformation];
    [VPTServiceManager logout];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalTableViewCell"];
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
