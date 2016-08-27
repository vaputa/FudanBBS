//
//  VPTTopTenTableViewCell.m
//  omega
//
//  Created by leon on 8/27/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTTopTenTableViewCell.h"

@implementation VPTTopTenTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
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
