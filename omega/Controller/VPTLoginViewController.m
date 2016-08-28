//
//  VPTLoginViewController.m
//  FudanBBS
//
//  Created by leon on 3/12/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "FlatUIKit.h"

#import "VPTLoginViewController.h"
#import "VPTServiceManager.h"

@interface VPTLoginViewController ()
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) FUITextField *username;
@property (nonatomic, strong) FUITextField *password;

@property (nonatomic, strong) UILabel *hint;
@end

@implementation VPTLoginViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@"登录"];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLoginView];
    [self.view addSubview:_loginView];
    [self updateViewConstraints];
    [_username becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:@"登录"];
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
    _username.cornerRadius = 10.0f;
    
    _password.font = [UIFont flatFontOfSize:16];
    _password.backgroundColor = [UIColor clearColor];
    _password.secureTextEntry = YES;
    _password.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    _password.textFieldColor = [UIColor whiteColor];
    _password.borderColor = [UIColor turquoiseColor];
    _password.borderWidth = 2.0f;
    _password.cornerRadius = 10.0f;
    
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
    _loginView.backgroundColor = [UIColor cloudsColor];
    
    [_loginView addSubview:_username];
    [_loginView addSubview:_password];
    [_loginView addSubview:button];
    
    [_username mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_loginView).multipliedBy(0.8);
        make.height.equalTo(@40);
        make.top.equalTo(_loginView).offset(5);
        make.centerX.equalTo(_loginView);
    }];
    [_password mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_username);
        make.height.equalTo(@40);
        make.top.equalTo(_username.mas_bottom).offset(5);
        make.centerX.equalTo(_loginView);
    }];
    
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginView);
        make.width.equalTo(_loginView).multipliedBy(0.25);
        make.top.equalTo(_password.mas_bottom).offset(5);
        make.height.equalTo(@30);
        make.bottom.lessThanOrEqualTo(_loginView).offset(-5);
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [_loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.width.equalTo(self.view);
    }];
}

- (void)login {
    [VPTServiceManager loginWithUsername:_username.text
                                password:_password.text
                                 success:^(NSDictionary *result) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [VPTServiceManager fetchAllBoards];
                                 } failure:^(NSDictionary *result) {
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                                         message:result[@"error"]
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"重新登录"
                                                                               otherButtonTitles:nil];
                                     [alertView show];
                                 }];
}

- (void)logout {
    [VPTServiceManager clearUserInformation];
    [VPTServiceManager logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
