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
#import <FlatUIKit/FlatUIKit.h>

#import "VPTTopTenViewController.h"
#import "VPTTopicViewController.h"
#import "VPTServiceManager.h"

@interface VPTTopTenViewController ()
@property (strong) UITableView *tableView;
@property (strong) NSMutableArray *topicArray;
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
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    [_tableView setContentInset:adjustForTabbarInsets];
    [_tableView setScrollIndicatorInsets:adjustForTabbarInsets];
    
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _topicArray = [[NSMutableArray alloc] init];
    [VPTNetworkService request:@"http://bbs.fudan.edu.cn/bbs/top10" delegate:self];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"今日十大"];    
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TOPTenCell"];
    NSDictionary *cellInfo = _topicArray[indexPath.row];
    [cell.textLabel setText:cellInfo[@"title"]];
    [cell.detailTextLabel setText:[[VPTServiceManager getAllBoardDictionary] objectForKey:cellInfo[@"attributes"][@"board"]][@"desc"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:cellInfo[@"attributes"][@"count"]];
    label.layer.cornerRadius = 15;
    label.layer.borderColor = [UIColor turquoiseColor].CGColor;
    label.layer.borderWidth = 1;
    [label setAdjustsFontSizeToFitWidth:YES];
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
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_topicArray count];
}

- (void)receiveData:(NSString *)data{
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    for (ONOXMLElement *element in [document.rootElement children]){
        if ([@"top" isEqualToString:[element tag]]){
            [_topicArray addObject:@{
                                     @"title":[[element stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                     @"attributes":[element attributes],
                                     }
             ];
        }
    }
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *cellInfo = [_topicArray objectAtIndex:indexPath.row];
    [cell setSelected:NO];
    VPTTopicViewController *tvc = [[VPTTopicViewController alloc] init];
    [tvc setGid:cellInfo[@"attributes"][@"gid"]];
    [tvc setBoardId:cellInfo[@"attributes"][@"board"]];
    [tvc setPostTitle:cellInfo[@"title"]];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
