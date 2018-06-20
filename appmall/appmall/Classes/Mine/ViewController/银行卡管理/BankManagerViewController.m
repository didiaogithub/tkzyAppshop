//
//  BankManagerViewController.m
//  appmall
//
//  Created by majun on 2018/6/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BankManagerViewController.h"
@interface BankManagerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation BankManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡管理";
//    http://tkre.klboo.com/payhtml/banklist.html?cid=1&token=d590537b12b7b7b0c902d804d393d98d
    NSString *token = [UserModel getCurUserToken];
    NSDictionary *para = @{@"cid":@"1",
                           @"token":token
                           };
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:para];
    NSString *requestUrl = [NSString connectUrl:paraDic url:@"http://tkre.klboo.com/payhtml/banklist.html?"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
