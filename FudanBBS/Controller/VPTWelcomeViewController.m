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
    [NetworkService request:@"http://bbs.fudan.edu.cn/bbs/boa?board=Celebration_19" delegate:self];
    [NetworkService request:@"http://bbs.fudan.edu.cn/bbs/boa?board=Zone_S.I.R.P.A." delegate:self];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)receiveData:(NSString *)data {
    data = [data stringByReplacingOccurrencesOfString:@"gb18030" withString:@"UTF-8"];
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:[data dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    NSMutableArray *_boards = [[NSMutableArray alloc] init];
    for (ONOXMLElement *boardEle in [[document rootElement] children]){
        if ([[boardEle tag] isEqualToString:@"brd"]) {
            [_boards addObject:[boardEle attributes]];
        }
    }
    NSLog(@"%@", _boards);
}

@end
