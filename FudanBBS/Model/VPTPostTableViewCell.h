//
//  PostTableViewCell.h
//  FudanBBS
//
//  Created by leon on 3/5/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPTPostTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *reply;
@property (nonatomic, strong) UILabel *user;
@property (nonatomic, strong) UIView *content;

- (void)buildContent:(NSMutableArray *)content;

@end
