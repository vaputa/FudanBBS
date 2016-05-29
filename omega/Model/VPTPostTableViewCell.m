//
//  PostTableViewCell.m
//  FudanBBS
//
//  Created by leon on 3/5/16.
//  Copyright © 2016 vaputa. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "VPTPostTableViewCell.h"
#import "Masonry/Masonry.h"

@implementation VPTPostTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _user = [[UILabel alloc] init];
        _date = [[UILabel alloc] init];
        _reply = [[UILabel alloc] init];
        _content = [[UIView alloc] init];
        
        [_user setFont:[UIFont systemFontOfSize:12]];
        
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
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(_content);
        }];
        [_date mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_user.mas_bottom);
            make.left.equalTo(_content);
        }];
        [_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).offset(-20);
            make.top.equalTo(_date.mas_bottom).offset(10);
            make.bottom.equalTo(_reply.mas_top).offset(-10);
            make.centerX.equalTo(self.contentView);
        }];
        [_reply mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.centerX.equalTo(self.contentView);
        }];

        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)buildContent:(NSMutableArray *)content withReload:(BOOL)reload {
    if ([_content subviews]) {
         for (UIView *view in [_content subviews]) {
             [view removeFromSuperview];
         }
    }
    MASViewAttribute* last = [_content mas_top];
    NSMutableArray *imageLoader = [NSMutableArray new];
    for (NSDictionary *para in content) {
        if ([[para objectForKey:@"type"] isEqualToString:@"text"]) {
            UILabel *label = [UILabel new];
            [label setText:[para objectForKey:@"text"]];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:14]];
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
            UIImageView *imageView = [[UIImageView alloc] init];
            [_content addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            if ([_imageDictionary objectForKey:url]) {
                UIImage *image = [_imageDictionary objectForKey:url];
                [imageView setImage:image];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.lessThanOrEqualTo(@(image.size.width));
                    make.height.lessThanOrEqualTo(@(image.size.height));
                    make.height.lessThanOrEqualTo(@(image.size.height / image.size.width * ([UIScreen mainScreen].bounds.size.width - 20)));
                }];
            } else {
                [imageLoader addObject:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_hot_selected"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        @synchronized(_imageDictionary) {
                            [_imageDictionary setObject:image forKey:url];
                        }
                        [subscriber sendCompleted];
                    }];
                    return nil;
                }]];
            }
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(_content);
                make.centerX.equalTo(_content);
                make.top.equalTo(last);
            }];
            last = [imageView mas_bottom];
        }
    }
    if (![_finishSet containsObject:_indexPath]) {
        if ([imageLoader count] > 0) {
            [[RACSignal combineLatest:imageLoader] subscribeCompleted:^{
                if (reload && ![_finishSet containsObject:_indexPath]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView beginUpdates];
                        [_tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [_tableView endUpdates];
                    });
                }
            }];
        } else {
            @synchronized(_finishSet) {
                [_finishSet addObject:_indexPath];
            }
        }
    }
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(last);
    }];
    [_content sizeToFit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
