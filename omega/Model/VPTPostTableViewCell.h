//
//  PostTableViewCell.h
//  FudanBBS
//
//  Created by leon on 3/5/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPTPostTableViewCell : UITableViewCell
@property (nonatomic) double height;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *reply;
@property (nonatomic, strong) UILabel *user;
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableSet *finishSet;
@property (nonatomic, strong) NSMutableDictionary *imageDictionary;

- (void)buildContent:(NSArray *)content;

@end
