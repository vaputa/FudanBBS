//
//  VPTReplyViewController.m
//  omega
//
//  Created by leon on 4/17/16.
//  Copyright © 2016 vaputa. All rights reserved.
//

#import "VPTReplyViewController.h"
#import "VPTServiceManager.h"

@interface VPTReplyViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation VPTReplyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    _textView = [UITextView new];
    [self.view addSubview:_textView];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:UIBarButtonItemStyleDone target:self action:@selector(reply)];
    _textView.font = [UIFont systemFontOfSize:20];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@250);
    }];
    [_textView becomeFirstResponder];
}

- (void)reply {
    [VPTServiceManager replyWithTitle:[NSString stringWithFormat:@"Re: %@", _reTitle] boardId:_boardID topic:_topicID text:_textView.text completionHandler:^(id result, NSError *error) {
        if (error) {
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
