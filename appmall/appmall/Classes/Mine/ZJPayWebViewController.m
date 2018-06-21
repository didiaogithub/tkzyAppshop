//
//  ZJPayWebViewController.m
//  appmall
//
//  Created by majun on 2018/6/20.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ZJPayWebViewController.h"
#import "SCOrderManagerViewController.h"
#import "ArrearsManagerViewController.h"
@interface ZJPayWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation ZJPayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中金快捷支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myWebView.delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    });
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *str = request.URL.absoluteString;
    NSString *paramStr = [str componentsSeparatedByString:@"://"].lastObject;
    NSString *paramStr1 = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSData *JSONData = [paramStr1 dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *paramDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *paramDic = [self dictionaryWithJsonString:paramStr1];
    NSLog(@"%@", paramDic);
    if ([str containsString:@"buy://"]) {
        [self buyNow:paramDic];
    }
    return YES;
}



- (void)buyNow:(NSDictionary *)dic{
//    oid = 1739;
//    type = 1;
    NSString *type;
    if (dic != nil) {
        type = dic[@"type"];
        if ([type isEqualToString:@"1"] ||[type isEqualToString:@"2"]) {
            if (self.isqkglPage == YES) {
                ArrearsManagerViewController *arrearsM = [[ArrearsManagerViewController alloc]init];
                arrearsM.selectedIndex = 3;
                arrearsM.fromVC = @"PaySuccess";
                [self.navigationController pushViewController:arrearsM animated:YES];
            }else{
                SCOrderManagerViewController *orderM = [[SCOrderManagerViewController alloc]init];
                orderM.selectedIndex = 2;
                orderM.fromVC = @"PaySuccess";
                [self.navigationController pushViewController:orderM animated:YES];
            }
        }
        
        
    }
    
    
    

//    NSString *money;
//    if (dic != nil) {
//        money = dic[@"money"];
// 
//    
//    [self.navigationController pushViewController:iwantEnrollVC animated:YES];
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


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


@end
