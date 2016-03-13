//
//  VPTBoardViewController.m
//  FudanBBS
//
//  Created by leon on 3/6/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTBoardListViewController.h"
#import "VPTTopicListViewController.h"
#import "Masonry/Masonry.h"
#import "Ono.h"


@interface VPTBoardListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *boards;
@property (nonatomic, strong) NSString *boardId;
@property (nonatomic, strong) NSString *boardDesc;
@property (nonatomic, strong) NSString *sectionId;
@property (nonatomic, strong) NSString *sectionDesc;
@property (nonatomic) enum BoardListViewType boardListViewType;
@end

@implementation VPTBoardListViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"所有板块"];
        _boardListViewType = BoardListViewTypeAllSections;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_boardListViewType == BoardListViewTypeAllSections) {
        [NetworkService request:@"http://bbs.fudan.edu.cn/bbs/sec" delegate:self];
    } else if (_boardListViewType == BoardListViewTypeAllBoardsForSection) {
        [NetworkService request:[NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/boa?s=%@", _sectionId] delegate:self];
    } else if (_boardListViewType == BoardListViewTypeSubdirectoryForSection) {
        [NetworkService request:[NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/boa?board=%@", _boardId] delegate:self];
    }
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VPTBoardViewCell"];
    if (_boardListViewType == BoardListViewTypeAllSections) {
        [cell.textLabel setText:[[[_sections objectAtIndex:indexPath.row] objectForKey:@"section"] objectForKey:@"desc"]];
    } else {
        [cell.textLabel setText:[[_boards objectAtIndex:indexPath.row] objectForKey:@"desc"]];
        if ([[_boards objectAtIndex:indexPath.row] objectForKey:@"cate"]) {
            [cell.detailTextLabel setText:[[_boards objectAtIndex:indexPath.row] objectForKey:@"cate"]];
        }
        if ([[[_boards objectAtIndex:indexPath.row] objectForKey:@"dir"] isEqualToString:@"1"]) {
            [cell setBackgroundColor:[UIColor colorWithRed:0 green:0.2 blue:0.8 alpha:1]];
        }
    }
    if (_boardListViewType == BoardListViewTypeRecommandedBoardsForSection && indexPath.row == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:0 green:0.2 blue:0.2 alpha:0.3]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    NSUInteger row = indexPath.row;
    if (_boardListViewType == BoardListViewTypeAllSections) {
        VPTBoardListViewController *bvc = [VPTBoardListViewController new];
        NSDictionary *dictionary = [_sections objectAtIndex:row];
        [bvc setBoards:dictionary[@"boards"]];
        [bvc setSectionId:dictionary[@"section"][@"id"]];
        [bvc setSectionDesc:dictionary[@"section"][@"desc"]];
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
            [tlvc setBoardName:_boards[row][@"desc"]];
            [tlvc setBoardId:_boards[row][@"name"]];
            [self.navigationController pushViewController:tlvc animated:YES];
        }
    } else if (_boardListViewType == BoardListViewTypeAllBoardsForSection || _boardListViewType == BoardListViewTypeSubdirectoryForSection){
        if ([_boards[row][@"dir"] isEqualToString:@"1"]) {
            VPTBoardListViewController *bvc = [VPTBoardListViewController new];
            [bvc setBoardListViewType:BoardListViewTypeSubdirectoryForSection];
            [bvc setBoardId:_boards[row][@"title"]];
            [bvc setBoardDesc:_boards[row][@"desc"]];
            [self.navigationController pushViewController:bvc animated:YES];
        } else {
            VPTTopicListViewController *tlvc = [VPTTopicListViewController new];
            [tlvc setBoardId:_boards[row][@"title"]];
            [tlvc setBoardName:_boards[row][@"desc"]];
            [self.navigationController pushViewController:tlvc animated:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_boardListViewType == BoardListViewTypeAllSections) {
        return [_sections count];
    } else {
        return [_boards count];
    }
}

- (void)receiveData:(NSString *)data {
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    if (_boardListViewType == BoardListViewTypeAllSections) {
        _sections = [[NSMutableArray alloc] init];
        for (ONOXMLElement *sectionEle in [[document rootElement] children]){
            if ([[sectionEle tag] isEqualToString:@"sec"]) {
                NSMutableDictionary *section = [NSMutableDictionary new];
                [section setObject:[sectionEle attributes] forKey:@"section"];
                [section setObject:[NSMutableArray new] forKey:@"boards"];
                for (ONOXMLElement *boardEle in [sectionEle children]) {
                    [[section objectForKey:@"boards"] addObject:[boardEle attributes]];
                }
                [[section objectForKey:@"boards"] insertObject:@{@"desc":@"所有子版块"} atIndex:0];
                [_sections addObject:section];
            }
        }
    } else {
        _boards = [[NSMutableArray alloc] init];
        for (ONOXMLElement *boardEle in [[document rootElement] children]){
            if ([[boardEle tag] isEqualToString:@"brd"]) {
                [_boards addObject:[boardEle attributes]];
            }
        }
    }
    [_tableView reloadData];
        
}

@end
