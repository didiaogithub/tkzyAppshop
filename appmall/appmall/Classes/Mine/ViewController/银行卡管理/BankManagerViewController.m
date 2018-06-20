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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
