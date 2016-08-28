//
//  VPTSimpleCell.m
//  omega
//
//  Created by leon on 8/28/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "VPTSimpleCell.h"
#import "FlatUIKit.h"
@interface VPTSimpleCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation VPTSimpleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        _detailLabel = [UILabel new];
        _iconImageView = [UIImageView new];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_iconImageView];
    }
    return self;
}


-(void)prepareForReuse {
    _titleLabel.text = nil;
    _detailLabel.text = nil;
}
- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setType:(enum VPTSimpleCellType)type {
    switch (type) {
        case VPTSimpleCellBoard:
            _iconImageView.image = [UIImage imageNamed:@"icon_board"];
            break;
        case VPTSimpleCellFolder:
            _iconImageView.image = [UIImage imageNamed:@"icon_folder"];
            break;
        case VPTSimpleCellTop:
            _iconImageView.image = [UIImage imageNamed:@"icon_top"];
            break;
        case VPTSimpleCellTopic:
            _iconImageView.image = [UIImage imageNamed:@"icon_topic"];
            break;
        case VPTSimpleCellFavourite:
            _iconImageView.image = [UIImage imageNamed:@"icon_favourite"];
            break;
        default:
            break;
    }
    if (type == VPTSimpleCellTop || type == VPTSimpleCellTopic) {
        _titleLabel.font = [UIFont flatFontOfSize:12];
    }
}

- (void)setDetail:(NSString *)detail {
    _detailLabel.text = detail;
}

- (void)updateConstraints {
    [super updateConstraints];
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@32);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];
    if (!_detailLabel.text) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
        }];
    } else {
        _titleLabel.font = [UIFont flatFontOfSize:14];
        _detailLabel.font = [UIFont flatFontOfSize:12];

        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).multipliedBy(0.65);
        }];
        [_detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.right.equalTo(self.contentView);
            make.top.equalTo(_titleLabel.mas_bottom);
            make.height.equalTo(self.contentView).multipliedBy(0.3);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
