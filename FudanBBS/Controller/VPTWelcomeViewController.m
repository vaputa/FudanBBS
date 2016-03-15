//
//  VPTWelcomeViewController.m
//  FudanBBS
//
//  Created by leon on 2/29/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTWelcomeViewController.h"
#import "Masonry/Masonry.h"
#import "Ono.h"

@interface VPTWelcomeViewController ()
@property (strong) UILabel *label;
@end

@implementation VPTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _label = [[UILabel alloc] init];
    [_label setText:@"Welcome to fudan university"];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_label];
    [self updateViewConstraints];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

@end
