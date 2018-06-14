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
#import "SCPayViewController.h"
#import "WBWuliuInfoVC.h"
#import "XWAlterVeiw.h"
#define KODWuliuCell @"ODWuliuCell"
#define KODGoodInfoViewCell @"ODGoodInfoViewCell"
#define KODOrderInfoViewCell @"ODOrderInfoViewCell"
#define KODGoodsTableViewCell @"ODGoodsTableViewCell"


@interface SCOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,XWAlterVeiwDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (weak, nonatomic) IBOutlet UITableView *tabOrderDetaiol;
@property (nonatomic, strong) OrderDetailModel *orderDetailModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnItem1;
@property (weak, nonatomic) IBOutlet UIButton *btnItem2;
@property (weak, nonatomic) IBOutlet UIButton *btnItem3;
@property(nonatomic,strong)UILabel *headLab;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@end

@implementation SCOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.topDis.constant = NaviHeight;
    [self setTableView];
    [self requestOrderDetailData];
    [self setBtn:_btnItem1 isRed:NO];
    [self setBtn:_btnItem2 isRed:NO];
    [self setBtn:_btnItem3 isRed:YES];
    [self setBottom:self.orderstatusString];
}

-(void)setBtn:(UIButton *)sender isRed:(BOOL)isRed{
    sender.layer.cornerRadius = 3;
    sender.layer.masksToBounds = YES;
    if (!isRed) {
        sender.layer.borderColor = RGBCOLOR(170, 170, 170).CGColor;
        sender.layer.borderWidth = 1;
    }else{
        sender.backgroundColor = [UIColor redColor];
    }
}


-(void)setBottom:(NSString *)state{
    //    （， 99：全部）
    
    //交易取消  0：已取消，4：正在退货， 5：退货成功
    //待付款  1：未付款
    // 待发货  2：已付款；
    // 待收货  7：已发货
    //交易成功 6：已完成，3：已收货
    if ([state isEqualToString:@"2"]) { //代发货
        self.viewBottom.hidden = YES;
        self.viewBottomHeight.constant = 0;
    }
    if ([state isEqualToString:@"6"] ||[state isEqualToString:@"3"]) {  //交易成功
        self.viewBottomHeight.constant = 0;
        self.viewBottom.hidden = YES;
        
//        [self.btnItem1 setTitle:@"联系客服" forState:0];
//
//        [self.btnItem1 addTarget:self  action:@selector(contactCS) forControlEvents:UIControlEventTouchUpInside];
//        [self.btnItem2 setTitle:@"查看物流" forState:0];
//        [self.btnItem2 addTarget:self action:@selector(lookWuLIU) forControlEvents:UIControlEventTouchUpInside];
//        [self.btnItem3 setTitle:@"确认收货" forState:0];
//         [self.btnItem3 addTarget:self  action:@selector(confirmReceiveAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([state isEqualToString:@"1"]) { // 代付款
        self.btnItem1.hidden = YES;
        [self.btnItem2 setTitle:@"取消订单" forState:0];
        
        [self.btnItem2 addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.btnItem3 setTitle:@"去付款" forState:0];
        [self.btnItem3 addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([state isEqualToString:@"7"]) { // 代收货
        self.btnItem1.hidden = YES;
        [self.btnItem2 setTitle:@"查看物流" forState:0];
        [self.btnItem2 addTarget:self action:@selector(lookWuLIU) forControlEvents:UIControlEventTouchUpInside];
        [self.btnItem3 setTitle:@"确认收货" forState:0];
        [self.btnItem3 addTarget:self  action:@selector(confirmReceiveAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ( [state isEqualToString:@"4"] || [state isEqualToString:@"5"]) {
        self.viewBottom .hidden = YES;
        self.viewBottomHeight.constant = 0;
    }
    if ([state isEqualToString:@"0"]) {
        self.btnItem1.hidden = YES;
        self.btnItem2.hidden = YES;
        [self.btnItem3 setTitle:@"删除订单" forState:0];
        [self.btnItem3 removeTarget:self  action:@selector(confirmReceiveAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.btnItem3 addTarget:self action:@selector(deleteOrderAlert) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)cancelOrder {
    
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定取消该订单？";
    _deleteAlertView.type = @"取消订单";
    [_deleteAlertView show];
    
}

-(void)confirmCancelOrder {
    NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:_orderModel.orderId forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:[dic valueForKey:@"message"]];
            return ;
        }
        [self showNoticeView:@"取消成功"];
        //取消成功后更新优惠券缓存
        [[SCCouponTools shareInstance] resquestValidCouponsData];
        [self .navigationController popViewControllerAnimated:YES];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}

-(void)contactCS {
        [[SobotManager shareInstance] startSobotCustomerService];
}

#pragma mark - 去付款
- (void)payOrder {
    SCMyOrderModel *orderM = self.orderModel;
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", orderM.ordermoney];
    
    payMoney.orderid = orderM.orderId;
    [self.navigationController pushViewController:payMoney animated:YES];
}

-(void)deleteOrder {
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    [paraDic setObject:self.orderid forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DelOrderUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"message"]];
            return ;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self showNoticeView:@"删除成功"];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)confirmReceiveAlert{
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定已经收到货物？";
    _deleteAlertView.type = @"确认收货";
    [_deleteAlertView show];
}

-(void)deleteOrderAlert{
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定删除订单？";
    _deleteAlertView.type = @"删除订单";
    [_deleteAlertView show];
}

-(void)subuttonClicked{
    
    if ([_deleteAlertView.type isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods];
    }else if ([_deleteAlertView.type isEqualToString:@"删除订单"]) {
        [self deleteOrder];
    }else if([_deleteAlertView.type isEqualToString:@"取消订单"]){
        [self confirmCancelOrder];
    }
}


-(void)confirmReceiveGoods {
    

    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    [paraDic setObject:self.orderid forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ConfirmReceiveUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"message"]];
            return ;
        }
        
        [self requestOrderDetailData];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
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
    }else if (indexPath.row == 3 + self.orderDetailModel.goods.count  ){
        ODOrderInfoViewCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODOrderInfoViewCell];
        [wuliuCell loadData:self.orderDetailModel];
        cell = wuliuCell;
    }else{
        ODGoodsTableViewCell *wuliuCell = [tableView dequeueReusableCellWithIdentifier:KODGoodsTableViewCell];
        wuliuCell.orderid = self.orderDetailModel.orderId;
        [wuliuCell loadData:self.orderDetailModel.goods[indexPath.row - 2]];
        [wuliuCell setCellBtnState:[self.orderstatusString integerValue]];
        cell = wuliuCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        return 110;
    }
    
    if (indexPath.row == 3 + self.orderDetailModel.goods.count) {
        return 145;
    }
    if ([self.orderstatusString integerValue ] == 3 ||[self.orderstatusString integerValue ] == 6 ) {
        return  140;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)lookWuLIU{
    WBWuliuInfoVC  *wuliuVC = [[WBWuliuInfoVC alloc]init];
    wuliuVC.goodSnum = self.orderModel.ordersheet.count;
    wuliuVC.orderid = self.orderModel.orderId;
    [self.navigationController pushViewController:wuliuVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self lookWuLIU];
    }
}


@end
