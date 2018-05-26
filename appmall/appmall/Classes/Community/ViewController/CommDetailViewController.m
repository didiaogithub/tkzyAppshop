
//
//  CommDetailViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommDetailViewController.h"

@interface CommDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabCommDetail;
@property (weak, nonatomic) IBOutlet UITableView *item;

@end

@implementation CommDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.tabCommDetail .delegate = self;
    self.tabCommDetail.dataSource = self;
//    [self.tabCommDetail registerNib:[UINib nibWithNibName:KCommPingLunViewCell bundle:nil] forCellReuseIdentifier:KCommPingLunViewCell];
}


-(void)loadData{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notiID forKey:@"noteid"];
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_GetCommunity];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.tabCommDetail.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommDetail tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
      
        [self.tabCommDetail tableViewEndRefreshCurPageCount:0];
        if (dic != nil) {
            
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
        
        [self.tabCommDetail reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}


@end
