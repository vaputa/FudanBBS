//
//  PostTableViewCell.m
//  FudanBBS
//
//  Created by leon on 3/5/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTPostTableViewCell.h"
#import "Masonry/Masonry.h"

@implementation VPTPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VPTPostTableViewCell"];
    if (self) {
        _user = [[UILabel alloc] init];
        _date = [[UILabel alloc] init];
        _reply = [[UILabel alloc] init];
        _content = [[UIView alloc] init];
        
        [_user setFont:[UIFont systemFontOfSize:15]];
        
        [_date setText:@"2015/01/01 00:00"];
        [_date setFont:[UIFont systemFontOfSize:12]];
        
        [_reply setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - 20];
        [_reply setNumberOfLines:0];
        [_reply setFont:[UIFont systemFontOfSize:10]];
        [_reply setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.3]];
        
        [self.contentView addSubview:_user];
        [self.contentView addSubview:_date];
        [self.contentView addSubview:_reply];
        [self.contentView addSubview:_content];

        [_user mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(_content);
        }];
        [_date mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_user.mas_bottom);
            make.left.equalTo(_content);
        }];
        [_reply mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.centerX.equalTo(self.contentView);
        }];
        [_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).offset(-20);
            make.top.equalTo(_date.mas_bottom).offset(10);
            make.bottom.equalTo(_reply.mas_top).offset(-10);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)buildContent:(NSMutableArray *)content {
    MASViewAttribute* last = [_content mas_top];
    for (NSDictionary *para in content) {
        if ([[para objectForKey:@"type"] isEqualToString:@"text"]) {
            UILabel *label = [UILabel new];
            [label setText:[para objectForKey:@"text"]];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:12]];
            [_content addSubview:label];
            [label setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - 20];
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_content);
                make.centerX.equalTo(_content);
                make.top.equalTo(last);
            }];
            last = [label mas_bottom];
        } else if ([[para objectForKey:@"type"] isEqualToString:@"image"]) {
            NSURL *url = [NSURL URLWithString:[para objectForKey:@"href"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_content addSubview:imageView];
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_content);
                make.centerX.equalTo(_content);
                make.top.equalTo(last);
                make.height.lessThanOrEqualTo(@300);
            }];
            last = [imageView mas_bottom];
        }
    }
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(last);
    }];
    [_content sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
