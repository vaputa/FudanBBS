//
//  VPTTopicViewController.m
//  FudanBBS
//
//  Created by leon on 3/2/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <Ono/Ono.h>

#import <NSDate_TimeAgo/NSDate+TimeAgo.h>
#import "FlatUIKit.h"

#import "VPTTopicViewController.h"
#import "VPTReplyViewController.h"
#import "VPTPostTableViewCell.h"
#import "VPTServiceManager.h"
#import "VPTUtil.h"
#import "VPTPost.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface VPTTopicViewController ()
@property (nonatomic) BOOL showQuote;
@property (nonatomic) BOOL isFavourite;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) FUIButton *prevPage;
@property (nonatomic, strong) FUIButton *nextPage;
@property (nonatomic, strong) UIButton *btnFavourite;
@property (nonatomic, strong) UIButton *btnQuote;
@property (nonatomic, strong) UIButton *btnReply;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *cells;
@property (nonatomic, strong) NSMutableDictionary *images;
@end

@implementation VPTTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VPTServiceManager fetchPostWithBoardId:_boardId gid:_gid fid:nil type:0 completionHandler:^(id result, NSError *error) {
        _dataSource = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableView];
        });
    }];

    _cells = [NSMutableDictionary new];
    _images = [NSMutableDictionary new];
    
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
    [_cells removeAllObjects];
    [_tableView reloadData];
}

- (UIView *)tableHeaderView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
    [label setNumberOfLines:0];
    [label setAttributedText:[[NSAttributedString alloc] initWithString:_postTitle attributes:@{NSForegroundColorAttributeName:[UIColor wetAsphaltColor],
                                                                                                NSFontAttributeName:[UIFont boldFlatFontOfSize:18]}]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label sizeToFit];
    return label;
}

- (UIView *)tableFooterView {
    if (_footerView) {
        return _footerView;
    }
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];

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
        make.width.equalTo(_footerView).dividedBy(3.0);
        make.height.equalTo(_footerView).offset(-10);
        make.right.equalTo(_footerView.mas_centerX);
        make.centerY.equalTo(_footerView);
    }];
    [_nextPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerView).dividedBy(3.0);
        make.height.equalTo(_footerView).offset(-10);
        make.left.equalTo(_footerView.mas_centerX);
        make.centerY.equalTo(_footerView);
    }];
    return _footerView;
}

- (void)goToNextPage {
    [VPTServiceManager fetchPostWithBoardId:_boardId gid:_gid fid:[(VPTPost *)[_dataSource lastObject] attributes][@"fid"] type:2 completionHandler:^(id result, NSError *error) {
        _dataSource = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableView];
        });
    }];
}
- (void)goToPrevPage {
    [VPTServiceManager fetchPostWithBoardId:_boardId gid:_gid fid:[(VPTPost *)[_dataSource firstObject] attributes][@"fid"] type:1 completionHandler:^(id result, NSError *error) {
        _dataSource = result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadTableView];
        });
    }];
}

- (void)reloadTableView {
    [_cells removeAllObjects];
    [_prevPage setHidden:[[(VPTPost *)[_dataSource firstObject] attributes][@"fid"] isEqualToString:_gid]];
    [_nextPage setHidden:[_dataSource count] != 20];
    [_footerView setHidden:[_nextPage isHidden] && [_prevPage isHidden]];
    if ([_footerView isHidden]) {
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    } else {
        [_tableView setTableFooterView:_footerView];
    }
    [_tableView setContentOffset:CGPointMake(0, -_tableView.contentInset.top) animated:NO];
    [_tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (_cells[indexPath] && [(VPTPostTableViewCell *)_cells[indexPath] ready]) {
        return _cells[indexPath];
    }
    VPTPostTableViewCell *cell = [VPTPostTableViewCell new];
    VPTPost *post = _dataSource[indexPath.row];
    [cell setTableView:_tableView];
    [cell setIndexPath:indexPath];
    [cell setImageDictionary:_images];
    [cell configureFlatCellWithColor:[UIColor cloudsColor]
                       selectedColor:nil
                     roundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
    cell.cornerRadius = 10;
    
    cell.date.text = [post.date timeAgo];
    
    NSString *text = [NSString stringWithFormat:@"%@ (%@)", post.owner, post.nick];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发信人: %@", text]];
    [attributeString addAttributes:@{NSForegroundColorAttributeName: [UIColor peterRiverColor]} range:NSMakeRange(5, [text length])];
    [cell.user setAttributedText:attributeString];
    
    if (_showQuote) {
        cell.reply.text = post.reply;
    } else {
        cell.reply.text = nil;
    }
    [cell buildContent:post.content];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    _cells[indexPath] = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VPTPostTableViewCell *cell = _cells[indexPath];
    if (cell == nil) {
        return 55;
    }
    return cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
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

@end
