//
//  ArrearsMListViewController.m
//  appmall
//
//  Created by majun on 2018/6/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsMListViewController.h"
#import "ArrearsTableCell.h"
#import "ArrearsFooterView.h"
#import "ArrearsHeaderView.h"
#import "arrearsModel.h"
#import "SCPayViewController.h"
#import "UITableView+XY.h"
@interface ArrearsMListViewController ()<UITableViewDelegate,UITableViewDataSource,ArrearsFooterViewDelegate>
@property (assign,nonatomic)NSInteger page;

/**  dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**  tableView*/
@property (nonatomic, strong) UITableView *mTableView;
@end

@implementation ArrearsMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    _page = 1;
    [self initComponments];
    [UITableView refreshHelperWithScrollView:self.mTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    [self loadNewData];
    self.isMyspon = NO;
}
- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"无欠款"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"还无此类欠款哦";
    return str;
}

-(void)loadNewData{
    _page =  1;
    if (self.isMyspon == YES) {
        [self getMySponListData];
    }else{
        [self getData:self.statusString];
    }
    
}

-(void)loadMoreData{
    _page ++;
    if (self.isMyspon == YES) {
        [self getMySponListData];
    }else{
        [self getData:self.statusString];
    }
}
- (void)initComponments{
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake( 0,10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 45 - 10) style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
}

- (void)getMySponListData{
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMySponList];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.mTableView.mj_header endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.mTableView tableViewEndRefreshCurPageCount:0];
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        
        if (_page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *Arr = dict[@"data"][@"list"];
        [self.mTableView tableViewEndRefreshCurPageCount:Arr.count];
        for (NSDictionary *dic in Arr) {
            arrearsModel *model = [[arrearsModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)getData:(NSString *)statusString{
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:statusString forKey:@"applystatus"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMyLoanList];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.mTableView.mj_header endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.mTableView tableViewEndRefreshCurPageCount:0];
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        
        if (_page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *Arr = dict[@"data"][@"loads"];
        [self.mTableView tableViewEndRefreshCurPageCount:Arr.count];
        for (NSDictionary *dic in Arr) {
            arrearsModel *model = [[arrearsModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

#pragma mark ---- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    arrearsModel *model = self.dataArray[section];
    return model.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ArrearsTableCell";//这个identifier跟xib设置的一样
    ArrearsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]
                loadNibNamed:@"ArrearsTableCell" owner:self options:nil]  lastObject];
    }
    arrearsModel *model = self.dataArray[indexPath.section];
    NSArray *ordersheet = model.items;
    [cell refreshData:ordersheet[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ArrearsHeaderView *view = [[ArrearsHeaderView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    arrearsModel *model = self.dataArray[section];
    view.orderNo.text = [NSString stringWithFormat:@"订单编码:%@",model.orderno];
    
    if ([model.statusLabel isEqualToString:@"待还款"]) {
        view.orderStates.text = [NSString stringWithFormat:@"距离最晚还款日还有%ld天",(long)model.limittime];
        view.orderStates.adjustsFontSizeToFitWidth = YES;
    }else{
        view.orderStates.text = model.statusLabel;
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ArrearsFooterView *view = [[ArrearsFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
    view.delegate = self;
    view.leftBtn.tag = section;
    view.rightBtn.tag = section;
    arrearsModel  * model = self.dataArray[section];
    
    view.orderTotal.font = [UIFont systemFontOfSize:18];
    NSString *str = model.statusLabel;
    if ([str isEqualToString:@"待还款"]) {
        view.leftBtn.hidden = YES;
        view.orderTotal.keyWordFont = [UIFont systemFontOfSize:13];
        view.orderTotal.text = [NSString stringWithFormat:@"合计：¥%.2f",[model.ordermoney floatValue]];
        view.orderTotal.keyWord = @"合计：";
        view.orderTotal.keyWordColor = [UIColor tt_bodyTitleColor];
        view.labserverFee.text = [NSString stringWithFormat:@"(手续费：%ld.00)",model.serviceCharge];
    }else if ([str isEqualToString:@"已还款"]){
        if (self.isMyspon == YES) {
            view.leftBtn.hidden = YES;
            view.rightBtn.hidden = YES;
            view.orderTotal.keyWordFont = [UIFont systemFontOfSize:13];
            view.orderTotal.text = [NSString stringWithFormat:@"合计：¥%.2f",[model.ordermoney floatValue]];
            view.orderTotal.keyWord = @"合计：";
            view.orderTotal.keyWordColor = [UIColor tt_bodyTitleColor];
            view.labserverFee.text = [NSString stringWithFormat:@"(手续费：%ld.00)",(long)model.serviceCharge];
            
        }else{
            view.orderTotal.textColor = [UIColor colorWithHexString:@"#6E6E6E"];
            view.orderTotal.font = [UIFont systemFontOfSize:13];
            view.leftBtn.hidden = YES;
            view.rightBtn.hidden = YES;
            view.orderTotal.text = [NSString stringWithFormat:@"还款时间：%@",model.paybacktime];
        }
    }else if (model.status == 1){ // 已拒绝
        if ([model.statusLabel isEqualToString:@"已取消"]) {
            view.leftBtn.hidden = YES;
            view.rightBtn.hidden = YES;
        }else{
            view.leftBtn.hidden = NO;
            view.rightBtn.hidden = YES;
            view.rwitdh.constant = - 70;
        }
        
        view.orderTotal.keyWordFont = [UIFont systemFontOfSize:13];
        view.orderTotal.text = [NSString stringWithFormat:@"合计：¥%.2f",[model.ordermoney floatValue]];
        view.orderTotal.keyWord = @"合计：";
        view.orderTotal.keyWordColor = [UIColor tt_bodyTitleColor];
        view.labserverFee.text = [NSString stringWithFormat:@"(手续费：%ld.00)",(long)model.serviceCharge];
    }else{
        view.leftBtn.hidden = YES;
        view.rightBtn.hidden = YES;
        view.orderTotal.keyWordFont = [UIFont systemFontOfSize:13];
        view.orderTotal.text = [NSString stringWithFormat:@"合计：¥%.2f",[model.ordermoney floatValue]];
        view.orderTotal.keyWord = @"合计：";
        view.orderTotal.keyWordColor = [UIColor tt_bodyTitleColor];
        view.labserverFee.text = [NSString stringWithFormat:@"(手续费：%ld.00)",(long)model.serviceCharge];
        
    }
    
    
    
    return view;
}

- (void)leftBtnAction:(UIButton *)sender{
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    arrearsModel  * model = self.dataArray[sender.tag];
    if (IsNilOrNull(model.orderid)) {
        return;
    }
    [pramaDic setObject:model.orderid forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelLoanOrder];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self showNoticeView:[dic valueForKey:@"message"]];
            return ;
        }
        [self showNoticeView:@"取消成功"];
        [self loadNewData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)rightBtnAction:(UIButton *)sender{
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    arrearsModel  * model = self.dataArray[sender.tag];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", model.ordermoney];
    payMoney.isqkglPage = YES;
    payMoney.money = model.ordermoney;
    payMoney.orderid = model.orderid;
    //    payMoney.orderid = orderM.orderId;
    //    NSString *orderNo = [NSString stringWithFormat:@"%@", model.orderno];
    //    if ([orderNo hasPrefix:@"ckdlb"]) {
    //        payMoney.isdlbitem = @"1";
    //    }
    [self.navigationController pushViewController:payMoney animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
