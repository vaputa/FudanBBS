//
//  PostTableViewCell.m
//  FudanBBS
//
//  Created by leon on 3/5/16.
//  Copyright © 2016 vaputa. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FlatUIKit.h"

#import "VPTPostTableViewCell.h"
#import "Masonry/Masonry.h"

@interface VPTPostTableViewCell ()
@property (nonatomic) BOOL isInUse;
@end

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
        
        _user.font = [UIFont boldFlatFontOfSize:14];
        
        [_date setText:@""];
        _date.textAlignment = NSTextAlignmentRight;
        [_date setFont:[UIFont systemFontOfSize:12]];
        
        [_reply setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - 20];
        [_reply setNumberOfLines:0];
        [_reply setFont:[UIFont systemFontOfSize:12]];
        
        [self.contentView addSubview:_user];
        [self.contentView addSubview:_date];
        [self.contentView addSubview:_content];
        [self.contentView addSubview:_reply];
        
        [_user mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(_content);
            make.width.equalTo(_content).multipliedBy(0.7);
        }];
        [_date mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_user);
            make.left.equalTo(_user.mas_right);
            make.right.equalTo(_content);
        }];
        [_content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.contentView).offset(-5);
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

- (void)prepareForReuse {
    if ([_content subviews]) {
        for (UIView *view in [_content subviews]) {
            [view removeFromSuperview];
        }
    }
}

- (void)buildContent:(NSArray *)content {
    MASViewAttribute* last = [_content mas_top];
    for (NSDictionary *para in content) {
        if ([[para objectForKey:@"type"] isEqualToString:@"text"]) {
            UILabel *label = [UILabel new];
            [label setText:[para objectForKey:@"text"]];
            [label setNumberOfLines:0];
            [label setTextColor:[UIColor midnightBlueColor]];
            [label setFont:[UIFont systemFontOfSize:16]];
            [_content addSubview:label];
            [label setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - 20];
            [label sizeToFit];
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
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_hot_selected"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    @synchronized(_imageDictionary) {
                        [_imageDictionary setObject:image forKey:url];
                        if (!imageView) {
                            return ;
                        }
                        [imageView setImage:image];
                        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.width.lessThanOrEqualTo(@(image.size.width));
                            make.height.lessThanOrEqualTo(@(image.size.height));
                            make.height.lessThanOrEqualTo(@(image.size.height / image.size.width * ([UIScreen mainScreen].bounds.size.width - 20)));
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                            [_tableView beginUpdates];
                            [_tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            [_tableView endUpdates];
                        });
                    }
                }];
            }
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.lessThanOrEqualTo(_content);
                make.centerX.equalTo(_content);
                make.top.equalTo(last).offset(10);
            }];
            last = [imageView mas_bottom];
        }
    }
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(last);
    }];
    [_content sizeToFit];
    _height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
