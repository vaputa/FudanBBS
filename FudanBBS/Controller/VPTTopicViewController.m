//
//  VPTTopicViewController.m
//  FudanBBS
//
//  Created by leon on 3/2/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "Masonry/Masonry.h"
#import "Ono.h"

#import "VPTTopicViewController.h"
#import "VPTPostTableViewCell.h"
#import "VPTDataManager.h"

@interface VPTTopicViewController ()
@property (nonatomic) BOOL showQuote;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *prevPage;
@property (nonatomic, strong) UIButton *nextPage;
@end

@implementation VPTTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NetworkService request:[self url] delegate:self];
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableHeaderView:[self tableHeaderView]];
    [_tableView setTableFooterView:[self tableFooterView]];
    
    [_footerView setHidden:YES];
    
    [_tableView registerClass:[VPTPostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _showQuote = YES;
    self.navigationItem.rightBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithTitle:@"Q"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(toggleQuote)],
                                               [[UIBarButtonItem alloc] initWithTitle:@"F"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(toggleFavourite)]
                                               ];
    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)toggleFavourite {
    [VPTDataManager AddToFavouriteTopicListWithBoardName:_boardName boardId:_boardId topicId:_gid title:_postTitle];
}

- (UIView *)tableHeaderView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    [label setText:_postTitle];
    [label setNumberOfLines:0];
    [label sizeToFit];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
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

- (void)goToNextPage {
    [NetworkService request:[self urlForNextPageWithBoard:_boardId gid:_gid fid:[_newsArray lastObject][@"attributes"][@"fid"]] delegate:self];
}
- (void)goToPrevPage {
    [NetworkService request:[self urlForPreviousPageWithBoard:_boardId gid:_gid fid:[_newsArray firstObject][@"attributes"][@"fid"]] delegate:self];
}

- (NSString *)url {
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&f=%@", _boardId, _gid];
}

- (NSString *)urlForPreviousPageWithBoard:(NSString *)board gid:(NSString *)gid fid:(NSString *)fid{
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&g=%@&f=%@&a=p", board, gid, fid];
}

- (NSString *)urlForNextPageWithBoard:(NSString *)board gid:(NSString *)gid fid:(NSString *)fid{
    return [NSString stringWithFormat:@"http://bbs.fudan.edu.cn/bbs/tcon?new=1&board=%@&g=%@&f=%@&a=n", board, gid, fid];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    VPTPostTableViewCell *cell = [[VPTPostTableViewCell alloc] init];
    [cell.date setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
    [cell.user setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
    [cell buildContent:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"content"]];

    if (_showQuote) {
        [cell.reply setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"reply"]];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VPTPostTableViewCell *cell = [[VPTPostTableViewCell alloc] init];
    [cell.date setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"date"]];
    [cell.user setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
    [cell buildContent:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
    if (_showQuote) {
        [cell.reply setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"reply"]];
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_newsArray count];
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

- (void)toggleQuote {
    _showQuote = !_showQuote;
    [_tableView reloadData];
}

- (void)receiveData:(NSString *)data {
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    _newsArray = [[NSMutableArray alloc] init];
    for (ONOXMLElement *child in [[document rootElement] children]){
        if ([[child tag] isEqualToString:@"po"]) {
            NSMutableDictionary *post = [NSMutableDictionary new];
            [post setObject:[[[child childrenWithTag:@"nick"] firstObject] stringValue] forKey:@"nick"];
            [post setObject:[[[child childrenWithTag:@"date"] firstObject] stringValue] forKey:@"date"];
            [post setObject:[[[child childrenWithTag:@"title"] firstObject] stringValue] forKey:@"title"];
            [post setObject:[[[child childrenWithTag:@"board"] firstObject] stringValue] forKey:@"board"];
            NSMutableArray *content = [NSMutableArray new];
            NSString *reply = @"";
            for (ONOXMLElement *pa in [child childrenWithTag:@"pa"]) {
                if ([[[pa attributes] objectForKey:@"m"] isEqualToString:@"t"]) {
                    for (ONOXMLElement *p in [pa childrenWithTag:@"p"]) {
                        if (![[[p stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                            [content addObject:@{
                                                 @"type": @"text",
                                                 @"text": [p stringValue]
                                                 }];
                        }
                        for (ONOXMLElement *a in [p childrenWithTag:@"a"]) {
                            if ([[a attributes][@"href"] hasPrefix:@"http://bbs.fudan.edu.cn/upload/"]) {
                                [content addObject:@{
                                                     @"type": @"image",
                                                     @"href": [a attributes][@"href"]
                                                     }];
                            }
                        }
                    }
                } else if ([[[pa attributes] objectForKey:@"m"] isEqualToString:@"q"]) {
                    for (ONOXMLElement *p in [pa children]){
                        if ([[p tag] isEqualToString:@"p"]) {
                            reply = [reply stringByAppendingFormat:@"%@\n", [p stringValue]];
                        }
                    }
                }
            }
            [post setObject:content forKey:@"content"];
            [post setObject:reply forKey:@"reply"];
            [post setObject:[child attributes] forKey:@"attributes"];
            [_newsArray addObject:post];
        }
    }
    [_prevPage setEnabled:![[_newsArray firstObject][@"attributes"][@"fid"] isEqualToString:_gid]];
    [_nextPage setEnabled:[_newsArray count] == 20];
    [_footerView setHidden:!([_nextPage isEnabled] || [_prevPage isEnabled])];
    [_tableView reloadData];
}

@end