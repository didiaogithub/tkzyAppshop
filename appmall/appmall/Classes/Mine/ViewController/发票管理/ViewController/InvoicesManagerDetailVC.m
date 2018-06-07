//
//  InvoicesManagerDetailVC.m
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerDetailVC.h"

@interface InvoicesManagerDetailVC ()

@end

@implementation InvoicesManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票详情";
    
    [self getData];
}

- (void)getData{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [paraDic setObject:self.orderid forKey:@"orderid"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInvoicedetailByIdApi];
    
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
