//
//  VPTSettingsViewController.m
//  FudanBBS
//
//  Created by leon on 3/12/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTSettingsViewController.h"
#import "Masonry/Masonry.h"
#import "NetworkService.h"

@interface VPTSettingsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *password;
@end

@implementation VPTSettingsViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"设置"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLoginView];
    _tableView = [UITableView new];
    [_tableView setTableHeaderView:_loginView];
    
    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)setUpLoginView {
    _username = [UITextField new];
    _password = [UITextField new];
    UIButton *button = [UIButton new];
    [_username setTintColor:[UIColor grayColor]];
    [_username setPlaceholder:@"用户名"];
    [_username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_username setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_username setFont:[UIFont systemFontOfSize:15]];
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_username setDelegate:self];
    
    [_password setTintColor:[UIColor grayColor]];
    [_password setPlaceholder:@"密码"];
    [_password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_password setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_password setFont:[UIFont systemFontOfSize:15]];
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_password setDelegate:self];
    
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor greenColor]];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    _loginView = [UIView new];
    [_loginView addSubview:_username];
    [_loginView addSubview:_password];
    [_loginView addSubview:button];
    
    [_username mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.top.equalTo(_loginView);
        make.centerX.equalTo(_loginView);
        make.height.equalTo(@30);
    }];
    [_password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_username);
        make.top.equalTo(_username.mas_bottom);
        make.centerX.equalTo(_loginView);
        make.height.equalTo(_username);
    }];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginView);
        make.width.equalTo(_loginView).multipliedBy(0.5);
        make.top.equalTo(_password.mas_bottom);
        make.height.equalTo(@30);
    }];
    
    [_loginView setFrame:CGRectMake(0, 0, 0, 100)];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginView.superview);
        make.centerX.equalTo(_loginView.superview);
        make.width.equalTo(_loginView.superview);
        make.height.equalTo(@100);
    }];
}
- (void)login {
    [NetworkService post:@"http://bbs.fudan.edu.cn/bbs/login" data:@{
                                                                     @"username": _username.text,
                                                                     @"password": _password.text
                                                                     } delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
