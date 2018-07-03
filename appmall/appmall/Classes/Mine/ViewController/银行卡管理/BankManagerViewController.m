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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self cleanCacheAndCookie];
}
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
    NSString *requestUrl = [NSString connectUrl:paraDic url:@"http://tkre.tcsw.com.cn/payhtml/banklist.html?"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
    });
}
/**清除缓存和cookie*/

- (void)cleanCacheAndCookie{
    
    //清除cookies
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies]){
        
        [storage deleteCookie:cookie];
        
    }
    
    //清除UIWebView的缓存
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSURLCache * cache = [NSURLCache sharedURLCache];
    
    [cache removeAllCachedResponses];
    
    [cache setDiskCapacity:0];
    
    [cache setMemoryCapacity:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
