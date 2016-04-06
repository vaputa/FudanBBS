//
//  VPTSettingsViewController.m
//  FudanBBS
//
//  Created by leon on 3/12/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <Ono/Ono.h>
#import <FlatUIKit/FlatUIKit.h>

#import "VPTSettingsViewController.h"
#import "VPTServiceManager.h"

@interface VPTSettingsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) FUITextField *username;
@property (nonatomic, strong) FUITextField *password;

@property (nonatomic, strong) UIView *userInformationView;
@property (nonatomic, strong) UILabel *usernameLabel;

@property (nonatomic, strong) UILabel *hint;
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
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 300)];
    [self setUpLoginView];
    [self setUpUserInformationView];
    _tableView = [UITableView new];
    [_tableView setTableHeaderView:_tableHeaderView];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_loginView setHidden:YES];
    [_usernameLabel setHidden:NO];
    [self.view addSubview:_tableView];
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"设置"];
    [self updateTableHeaderView];
}

- (void)updateTableHeaderView {
    if ([VPTServiceManager getUserInformation][@"username"]) {
        [_usernameLabel setText:[VPTServiceManager getUserInformation][@"username"]];
        [_userInformationView setHidden:NO];
        [_loginView setHidden:YES];
    } else {
        [_userInformationView setHidden:YES];
        [_loginView setHidden:NO];
    }
}

- (void)setUpUserInformationView {
    _usernameLabel = [UILabel new];
    _userInformationView = [UIView new];
    UIButton *logoutButton = [UIButton new];
    [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor lightGrayColor]];
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];

    [_userInformationView addSubview:_usernameLabel];
    [_userInformationView addSubview:logoutButton];
    
    [_usernameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_userInformationView);
        make.width.equalTo(@300);
    }];
    [logoutButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userInformationView);
        make.width.equalTo(_userInformationView).multipliedBy(0.5);
        make.top.equalTo(_usernameLabel.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.bottom.equalTo(_userInformationView);
    }];
    [_tableHeaderView addSubview:_userInformationView];
}

- (void)setUpLoginView {
    _username = [FUITextField new];
    _password = [FUITextField new];
    FUIButton *button = [FUIButton new];
    [_username setPlaceholder:@"用户名"];
    [_username setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_username setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_username setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_username setDelegate:self];
    
    [_password setPlaceholder:@"密码"];
    [_password setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_password setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_password setDelegate:self];
    
    _username.font = [UIFont flatFontOfSize:16];
    _username.backgroundColor = [UIColor clearColor];
    _username.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    _username.textFieldColor = [UIColor whiteColor];
    _username.borderColor = [UIColor turquoiseColor];
    _username.borderWidth = 2.0f;
    _username.cornerRadius = 3.0f;
    
    _password.font = [UIFont flatFontOfSize:16];
    _password.backgroundColor = [UIColor clearColor];
    _password.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    _password.textFieldColor = [UIColor whiteColor];
    _password.borderColor = [UIColor turquoiseColor];
    _password.borderWidth = 2.0f;
    _password.cornerRadius = 3.0f;
    
    
    button.buttonColor = [UIColor turquoiseColor];
    button.shadowColor = [UIColor greenSeaColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    _loginView = [UIView new];
    _loginView.layer.cornerRadius = 5;
    
    [_loginView addSubview:_username];
    [_loginView addSubview:_password];
    [_loginView addSubview:button];
    
    [_username mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_loginView).multipliedBy(0.8);
        make.top.equalTo(_loginView);
        make.centerX.equalTo(_loginView);
    }];
    [_password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_username);
        make.top.equalTo(_username.mas_bottom);
        make.centerX.equalTo(_loginView);
    }];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginView);
        make.width.equalTo(_loginView).multipliedBy(0.25);
        make.top.equalTo(_password.mas_bottom);
        make.height.equalTo(@30);
        make.bottom.lessThanOrEqualTo(_loginView);
    }];
    
    [_tableHeaderView addSubview:_loginView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_tableHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.superview);
        make.centerX.equalTo(_tableHeaderView.superview);
        make.width.equalTo(_tableHeaderView.superview);
        make.height.equalTo(@300);
    }];
    [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_tableHeaderView);
        make.width.equalTo(_tableHeaderView);
    }];
    [_userInformationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableHeaderView);
    }];
}

- (void)login {
    [VPTNetworkService post:@"http://bbs.fudan.edu.cn/bbs/login"
                       data:@{
                              @"username": _username.text,
                              @"password": _password.text
                              }
                   delegate:self];
}

- (void)logout {
    [VPTServiceManager clearUserInformation];
    [VPTNetworkService request:@"http://bbs.fudan.edu.cn/bbs/logout" delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)receiveData:(NSString *)data {
    if ([data hasPrefix:@"<html>"] || data == nil) {
        [_hint setText:@"用户名和密码不匹配"];
    } else {
        data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
        NSString *nickname = [[[[[[document rootElement] childrenWithTag:@"session"] firstObject] childrenWithTag:@"u"] firstObject] stringValue];
        NSDictionary *userInformation = @{@"username": nickname };
        [VPTServiceManager setUserInformation:userInformation];
    }
    [self updateTableHeaderView];
}

@end
