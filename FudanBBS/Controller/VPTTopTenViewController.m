//
//  VPTTopTenViewController.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Masonry/Masonry.h"
#import "Ono.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "VPTTopTenViewController.h"
#import "VPTTopicViewController.h"

@interface VPTTopTenViewController ()
@property (strong) UITableView *tableView;
@property (strong) NSMutableArray *newsArray;
@end

@implementation VPTTopTenViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"今日十大"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];

    _newsArray = [[NSMutableArray alloc] init];
    
    [NetworkService request:@"http://bbs.fudan.edu.cn/bbs/top10" delegate:self];
    [self updateViewConstraints];
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
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TOPTenCell"];
    [cell.textLabel setText:_newsArray[row][@"title"]];
    [cell.detailTextLabel setText:_newsArray[row][@"attributes"][@"board"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_newsArray count];
}

- (void)receiveData:(NSString *)data{
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    for (ONOXMLElement *element in [document.rootElement children]){
        if ([@"top" isEqualToString:[element tag]]){
            [_newsArray addObject:@{
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
    NSDictionary *dict = [_newsArray objectAtIndex:indexPath.row];
    [cell setSelected:NO];
    VPTTopicViewController *tvc = [[VPTTopicViewController alloc] init];
    [tvc setGid:dict[@"attributes"][@"gid"]];
    [tvc setBoardId:dict[@"attributes"][@"board"]];
    [tvc setPostTitle:dict[@"title"]];
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
