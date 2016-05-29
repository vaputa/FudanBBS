//
//  VPTTopicViewController.m
//  FudanBBS
//
//  Created by leon on 3/2/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <Ono/Ono.h>

#import "VPTTopicViewController.h"
#import "VPTReplyViewController.h"
#import "VPTPostTableViewCell.h"
#import "VPTServiceManager.h"
#import "VPTUtil.h"

@interface VPTTopicViewController ()
@property (nonatomic) BOOL showQuote;
@property (nonatomic) BOOL isFavourite;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *prevPage;
@property (nonatomic, strong) UIButton *nextPage;
@property (nonatomic, strong) UIButton *btnFavourite;
@property (nonatomic, strong) UIButton *btnQuote;
@property (nonatomic, strong) UIButton *btnReply;
@property (nonatomic, strong) NSMutableDictionary *imageDirectory;
@property (nonatomic, strong) NSMutableSet *finishSet;
@end

@implementation VPTTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VPTNetworkService request:[self url] delegate:self];
    _imageDirectory = [NSMutableDictionary new];
    _finishSet = [NSMutableSet new];

    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setTableHeaderView:[self tableHeaderView]];
    [_tableView setTableFooterView:[self tableFooterView]];
    _tableView.bounces = NO;

    [_footerView setHidden:YES];
    
    [_tableView registerClass:[VPTPostTableViewCell class] forCellReuseIdentifier:@"PostTableViewCell"];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _showQuote = YES;
    _isFavourite = [VPTServiceManager isFavouriteTopicWithBoardId:_boardId topicId:_gid];
    
    _btnQuote = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_btnQuote setBackgroundImage:[UIImage imageNamed:@"icon_quote"] forState:UIControlStateNormal];
    [_btnQuote addTarget:self action:@selector(toggleQuote) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFavourite = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_btnFavourite setBackgroundImage:[UIImage imageNamed:_isFavourite ? @"icon_favourite" : @"icon_unfavourite"] forState:UIControlStateNormal];
    [_btnFavourite addTarget:self action:@selector(toggleFavourite) forControlEvents:UIControlEventTouchUpInside];
    
    _btnReply = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_btnReply setBackgroundImage:[UIImage imageNamed:@"icon_reply"] forState:UIControlStateNormal];
    [_btnReply addTarget:self action:@selector(replyTopic) forControlEvents:UIControlEventTouchUpInside];

    [_tableView registerClass:[VPTPostTableViewCell class] forCellReuseIdentifier:@"VPTPostTableViewCell"];
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithCustomView:_btnReply],
                                                [[UIBarButtonItem alloc] initWithCustomView:_btnQuote],
                                                [[UIBarButtonItem alloc] initWithCustomView:_btnFavourite],
                                               ];
    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)replyTopic {
    VPTReplyViewController *rvc = [VPTReplyViewController new];
    [rvc setTopicID:_gid];
    [rvc setBoardID:_boardId];
    [rvc setReTitle:_postTitle];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)toggleFavourite {
    if (_isFavourite) {
        [VPTServiceManager removeFromFavouriteTopicListWithBoardName:_boardName boardId:_boardId topicId:_gid];
    } else {
        [VPTServiceManager addToFavouriteTopicListWithBoardName:_boardName boardId:_boardId topicId:_gid title:_postTitle];
    }
    _isFavourite = !_isFavourite;
    [_btnFavourite setBackgroundImage:[UIImage imageNamed:_isFavourite ? @"icon_favourite" : @"icon_unfavourite"] forState:UIControlStateNormal];
}

- (void)toggleQuote {
    _showQuote = !_showQuote;
    [_btnQuote setBackgroundImage:[UIImage imageNamed:_showQuote ? @"icon_quote" : @"icon_unquote"] forState:UIControlStateNormal];
    [_tableView reloadData];
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
    if (_footerView) {
        return _footerView;
    }
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

- (void)goToNextPage {
    [VPTNetworkService request:[self urlForNextPageWithBoard:_boardId gid:_gid fid:[_newsArray lastObject][@"attributes"][@"fid"]] delegate:self];
}
- (void)goToPrevPage {
    [VPTNetworkService request:[self urlForPreviousPageWithBoard:_boardId gid:_gid fid:[_newsArray firstObject][@"attributes"][@"fid"]] delegate:self];
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
    VPTPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VPTPostTableViewCell" forIndexPath:indexPath];
    [cell setTableView:_tableView];
    [cell setIndexPath:indexPath];
    [cell setFinishSet:_finishSet];
    [cell setImageDictionary:_imageDirectory];
    
    NSDate *date = [[_newsArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    [cell.date setText:[VPTUtil dateToString:date]];

    [cell.user setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
    [cell buildContent:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"content"] withReload:YES];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (_showQuote) {
        [cell.reply setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"reply"]];
    } else {
        [cell.reply setText:nil];
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
    [cell setTableView:_tableView];
    [cell setIndexPath:indexPath];
    [cell setFinishSet:_finishSet];
    [cell setImageDictionary:_imageDirectory];

    NSDate *date = [[_newsArray objectAtIndex:indexPath.row] objectForKey:@"date"];
    [cell.date setText:[VPTUtil dateToString:date]];
    
    [cell.user setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"nick"]];
    [cell buildContent:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"content"] withReload:NO];
    if (_showQuote) {
        [cell.reply setText:[[_newsArray objectAtIndex:indexPath.row] objectForKey:@"reply"]];
    } else {
        [cell.reply setText:nil];
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

- (void)receiveData:(NSString *)data {
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    _newsArray = [[NSMutableArray alloc] init];
    for (ONOXMLElement *child in [[document rootElement] children]){
        if ([[child tag] isEqualToString:@"po"]) {
            NSMutableDictionary *post = [NSMutableDictionary new];
            post[@"nick"] = [[[child childrenWithTag:@"nick"] firstObject] stringValue];
            post[@"date"] = [VPTUtil dateFromString:[[[child childrenWithTag:@"date"] firstObject] stringValue]];
            post[@"title"] = [[[child childrenWithTag:@"title"] firstObject] stringValue];
            post[@"board"] = [[[child childrenWithTag:@"board"] firstObject] stringValue];
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
    [_prevPage setHidden:[[_newsArray firstObject][@"attributes"][@"fid"] isEqualToString:_gid]];
    [_nextPage setHidden:[_newsArray count] != 20];
    [_footerView setHidden:[_nextPage isHidden] && [_prevPage isHidden]];
    if ([_footerView isHidden]) {
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    } else {
        [_tableView setTableFooterView:_footerView];
    }
    [_tableView reloadData];
    [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top) animated:NO];
}

@end
