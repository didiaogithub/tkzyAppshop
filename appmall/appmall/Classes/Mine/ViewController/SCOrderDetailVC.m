//
//  SCOrderDetailVC.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCOrderDetailVC.h"
#import "ODWuliuCell.h"
#import "ODGoodInfoViewCell.h"
#import "ODOrderInfoViewCell.h"
#import "ODGoodsTableViewCell.h"
#import "SCOrderDetailModel.h"
#import "OrderDetailModel.h"

#define KODWuliuCell @"ODWuliuCell"
#define KODGoodInfoViewCell @"ODGoodInfoViewCell"
#define KODOrderInfoViewCell @"ODOrderInfoViewCell"
#define KODGoodsTableViewCell @"ODGoodsTableViewCell"


@interface SCOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *tabOrderDetaiol;
@property (nonatomic, strong) OrderDetailModel *orderDetailModel;
@property(nonatomic,strong)UILabel *headLab;
@end

@implementation SCOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDis.constant = NaviHeight;
    [self setTableView];
    [self requestOrderDetailData];
}

-(void)setTableView{
    self.tabOrderDetaiol.delegate = self;
    self.tabOrderDetaiol.dataSource = self;
    
    [self.tabOrderDetaiol registerNib:[UINib nibWithNibName:KODGoodInfoViewCell bundle:nil] forCellReuseIdentifier:KODGoodInfoViewCell];
      [self.tabOrderDetaiol registerNib:[UINib nibWithNibName:KODOrderInfoViewCell bundle:nil] forCellReuseIdentifier:KODOrderInfoViewCell];
      [self.tabOrderDetaiol registerNib:[UINib nibWithNibName:KODGoodsTableViewCell bundle:nil] forCellReuseIdentifier:KODGoodsTableViewCell];
      [self.tabOrderDetaiol registerNib:[UINib nibWithNibName:KODWuliuCell bundle:nil] forCellReuseIdentifier:KODWuliuCell];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, KscreenWidth - 40, 25)];
    self.headLab.textColor = [UIColor whiteColor];
    self.headLab.font = [UIFont systemFontOfSize: 20];
    self.headLab .text = [self.orderDetailModel getOrderTitleInfo];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth , 61)];
    header.backgroundColor = [UIColor redColor];
    [header addSubview: self.headLab];
    return header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  4 + self.orderDetailModel.goods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        ODWuliuCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODWuliuCell];
        [wuliuCell loadLogData:self.orderDetailModel];
        cell = wuliuCell;
    }else if (indexPath.row == 1){
        ODWuliuCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODWuliuCell];
        [wuliuCell loadAddData:self.orderDetailModel];
        cell = wuliuCell;
    }else if (indexPath.row == 2 +self.orderDetailModel.goods.count ){
        ODGoodInfoViewCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODGoodInfoViewCell];
        [wuliuCell loadData:self.orderDetailModel];
        cell = wuliuCell;
    }else if (indexPath.row == 4){
        ODGoodInfoViewCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODOrderInfoViewCell];
        [wuliuCell loadData:self.orderDetailModel];
        cell = wuliuCell;
    }else{
        ODGoodsTableViewCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODGoodsTableViewCell];
        [wuliuCell loadData:self.orderDetailModel.goods[indexPath.row - 2]];
        cell = wuliuCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.orderDetailModel.logistics == nil) {
            return 0;
        }else{
            return 80;
        }
    }
    
    if (indexPath.row == 1) {
        return 100;
    }
    
    if (indexPath.row == 2 + self.orderDetailModel.goods.count) {
        return 85;
    }
    
    if (indexPath.row == 3 + self.orderDetailModel.goods.count) {
        return 135;
    }
    if ([self.orderDetailModel.goods[indexPath.row - 2].feedback boolValue] == YES) {
        return  118;
    }else{
        return 90;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 62;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)requestOrderDetailData{

    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,OrderDetailUrl];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.orderid forKey:@"orderid"];
    
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        
        _orderDetailModel = [[OrderDetailModel alloc] initWith:dict[@"data"]];
        [self.tabOrderDetaiol reloadData];

    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}


@end
