//
//  SCOrderListViewController.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/10/9.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//




//    订单状态（99：全部0：已取消 1：未付款；2：已付款；3:已收货 4：正在退货，5：退货成功，6：已完成，7：已发货 8  支付中）
//    订单状态（0：未付款 1：已取消 2：已付款 3：确认收货 4：退货中 5：退货完成 6：已完成 7：已发货 99：全部）
//1 - > 2 -> 7 -> 3 ->6
//
/*0：已取消；1：未付款；2：已付款；
 3：已收货，4：正在退货，
 5：退货成功，6：已完成，7：已发货*/

#import "SCOrderListViewController.h"
#import "SCOrderListCell.h"
#import "WBWuliuInfoVC.h"
#import "SCMyOrderModel.h"
#import "SCOrderDetailVC.h"
#import "OrderFooterView.h"
#import "SCPayViewController.h"
#import "DetailLogisticsViewController.h"
#import "SCGoodsDetailViewController.h"
#import "XWAlterVeiw.h"
#import "PaySuccessViewController.h"
#import "SCWaitReleaseCommentViewController.h"
#import "SearchTopView.h"
#import "SCCommentOrderViewController.h"
#import "InvoicesManagerViewController.h"

static NSString *cellIdentifier = @"SCOrderListCell";

@interface SCOrderListViewController()<UITableViewDelegate, UITableViewDataSource, XWAlterVeiwDelegate, UITextFieldDelegate, SearchTopViewDelegate, OrderFooterViewDelegate,XYTableViewDelegate>{
    SCMyOrderModel *orderModel;
}
@property (nonatomic, strong) NSString *oidString;
@property (nonatomic, strong) UILabel *indicateLine;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) NSMutableArray *statusBtnArr;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, strong) SearchTopView *searchView;
@property (nonatomic, strong) OrderFooterView *footerView;
@property (nonatomic, strong) UIButton *allOrderButton; //全部订单
@property (nonatomic, strong) UIButton *waitPayMoneyButton; //待付款
@property (nonatomic, strong) UIButton *waitDispatchGoodsButton; //待发货
@property (nonatomic, strong) UIButton *waitConsigneeButton; //待收货
@property (nonatomic, strong) UIButton *afterSalesButton; //售后
@property (nonatomic, strong) UILabel *orderNumberLable;  //订单编号
@property (nonatomic, strong) UILabel *orderStateLable;  //订单状态
@property (nonatomic, strong) SCMyOrderModel *orderModel;
@property (nonatomic, strong) XWAlterVeiw *cancelOrderAlert;
@property (nonatomic, strong) XWAlterVeiw *confirmAlert;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;
@property (nonatomic, strong) UIView *statusView;
@property(assign,nonatomic)NSInteger page;
@property(nonatomic,strong)NSMutableArray <SCMyOrderModel * >*orderDataArr;
@end



@implementation SCOrderListViewController

-(NSMutableArray *)orderDataArr {
    if (_orderDataArr == nil) {
        _orderDataArr = [NSMutableArray array];
    }
    return _orderDataArr;
}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"我的订单默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无此类订单哦";
    return str;
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(IsNilOrNull(self.statusString)){
        self.statusString = @"99";
    }
    [self loadMyOrderData:self.searchView.searchTextField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单列表";
    _page  =1;
    _statusArr = @[@"99", @"1", @"2", @"4,5,7", @"3,6"];
    
//    [self createTopButton];
//    [self moveStatusLineWithStatus:self.statusString];
    [self createTableView];
    [self refreshData];
    
    [UITableView refreshHelperWithScrollView:self.orderTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
}

-(void)zj_viewWillAppearForIndex:(NSInteger)index{
    self.statusString = _statusArr[index];
    [self loadNewData];
}


-(void)loadNewData{
    _page =  1;
    [self loadMyOrderData:_searchView.searchTextField.text];
}

#pragma mark - 请求订单列表数据
-(void)loadMyOrderData:(NSString*)searchkey {
    
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    
    
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
  
        [pramaDic setValuesForKeysWithDictionary:@{@"pageNo":@(_page),@"pageSize":@(KpageSize),@"orderstatus":self.statusString}];
    
    NSString *orderListUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GetOrderListUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:orderListUrl params:pramaDic success:^(id json) {
        
        [self.orderTableView.mj_header endRefreshing];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:itemDic[@"message"]];
            return;
        }
        if (self.page == 1) {
            [self.orderDataArr removeAllObjects];
        }
        for (NSDictionary *orderItemDIc in itemDic[@"data"][@"orderlist"]) {
            orderModel = [[SCMyOrderModel alloc] initWith:orderItemDIc];
            [_orderDataArr addObject:orderModel];
        }
        [self .orderTableView reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.orderTableView.mj_header endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        [self.loadingView stopAnimation];
    }];
}

/**创建订单状态按钮*/
-(void)createTopButton{
    
    _searchView = [[SearchTopView alloc] initWithFrame:CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, 0.1) andHeight:0.1];
    _searchView.searchTextField.placeholder = @"商品名称/订单号/收件人/收件人电话/昵称";
    _searchView.delegate = self;
//    [self.view addSubview:_searchView];
}

#pragma mark - 搜索代理方法
-(void)keyboardSearchWithString:(NSString *)searchStr {
    
    [self loadMyOrderData:_searchView.searchTextField.text];
    
}

-(void)clickBtnSearch:(UIButton *)button {
    NSLog(@"按键搜索");
    [_searchView.searchTextField resignFirstResponder];
    [self loadMyOrderData:_searchView.searchTextField.text];
}



#pragma mark-创建tableView
-(void)createTableView{
    
    _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,2, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStyleGrouped];
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderTableView];
    
    _orderTableView.estimatedRowHeight = 44;
    _orderTableView.estimatedSectionHeaderHeight = 0;
    _orderTableView.estimatedSectionFooterHeight = 0;
    _orderTableView.backgroundColor = [UIColor tt_grayBgColor];
    [_orderTableView registerClass:[SCOrderListCell class] forCellReuseIdentifier:cellIdentifier];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SCMyOrderModel *orderM = self.orderDataArr[section];
    return orderM.ordersheet.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SCOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.orderDataArr count]) {
        SCMyOrderModel *orderM = self.orderDataArr[indexPath.section];
        SCMyOrderGoodsModel *goodsM = orderM.ordersheet[indexPath.row];
        [cell refreshWithModel:goodsM];
    }
    
    return cell;
}

/**段头*/
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    _orderNumberLable = [UILabel configureLabelWithTextColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:MAIN_TITLE_FONT];
    [headerView addSubview:_orderNumberLable];
    _orderNumberLable.text = @"订单编号:";
    [_orderNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(0);
        make.height.mas_offset(45);
    }];
    _orderNumberLable.adjustsFontSizeToFitWidth = YES;
    UILabel *qian = [UILabel configureLabelWithTextColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:MAIN_TITLE_FONT];
    qian.layer.masksToBounds = YES;
    qian.layer.cornerRadius = 3;
    qian.text = @"欠";
  
    
    _orderStateLable = [UILabel configureLabelWithTextColor:[UIColor tt_redMoneyColor] textAlignment:NSTextAlignmentRight font:MAIN_TITLE_FONT];
    _orderStateLable.text = @"";
    [headerView addSubview:_orderStateLable];
    [_orderStateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.mas_equalTo(80);
    }];
    
    
    UILabel  *headertLineLable = [UILabel creatLineLable];
    [headerView addSubview:headertLineLable];
    headertLineLable.frame = CGRectMake(10, 45, SCREEN_WIDTH-20, 1);
    if ([self.orderDataArr count]) {
        
        SCMyOrderModel *orderModel = self.orderDataArr[section];
        _orderStateLable.text = [NSString stringWithFormat:@"%@",orderModel.orderstatuslabel];
        
//        NSString *orderfrom = [NSString stringWithFormat:@"%@", orderModel.orderfrom];
//        if ([orderfrom isEqualToString:@"3"]) {
//            //退换货才加标识
//            NSString *orderNo = [NSString stringWithFormat:@"订单编号：%@", orderModel.orderno];
//            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:orderNo];
//            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//            attch.image = [UIImage imageNamed:@"order_changeGoods"];
//            attch.bounds = CGRectMake(5, -5, 25, 25);
//            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//            [attri appendAttributedString:string];
//            _orderNumberLable.attributedText = attri;
//        }else{
            _orderNumberLable.text = [NSString stringWithFormat:@"订单编号：%@", orderModel.orderno];
        
        qian.frame = CGRectMake(_orderNumberLable.mj_x + _orderNumberLable.mj_textWith + 15, 10, 25, 25);
        
        qian.backgroundColor = [UIColor redColor];
        if ([orderModel.ordertypelabel containsString:@"欠"]) {
            
            [headerView addSubview:qian];
        }else if([orderModel.ordertypelabel containsString:@"保"]){
            qian.text = @"保";
            [headerView addSubview:qian];
        }else{
            [headerView removeFromSuperview];
        }
        
//        }
    }
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
//*段尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    SCMyOrderModel *orderModel = self.orderDataArr[section];
    NSString *statustr = [NSString stringWithFormat:@"%@",orderModel.orderstatuslabel];
    
    if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]) {
    
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        bgview.backgroundColor = [UIColor tt_grayBgColor];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [bgview addSubview:view];
       
        NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.orderpaymoney];
        if (IsNilOrNull(allMoney)) {
            allMoney = @"0.00";
        }
         UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor tt_monthGrayColor];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        // 手续费
//        UILabel *label1 = [[UILabel alloc]init];
//        label1.textColor = [UIColor tt_monthGrayColor];
//        label1.backgroundColor = [UIColor whiteColor];
//        label1.textAlignment = NSTextAlignmentLeft;
        
        if (iphone4) {
            label.font = CHINESE_SYSTEM(11);
        }else if (iphone5){
            label.font = CHINESE_SYSTEM(14);
        }else{
            label.font = CHINESE_SYSTEM(15);
        }
//        if (iphone4) {
//            label1.font = CHINESE_SYSTEM(11);
//        }else if (iphone5){
//            label1.font = CHINESE_SYSTEM(14);
//        }else{
//            label1.font = CHINESE_SYSTEM(15);
//        }
        
//        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)orderModel.itemlistArr.count];
        NSString *str = [NSString stringWithFormat:@"支付合计:¥%@", allMoney];
      
        
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:str];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1 = [[hintString string]rangeOfString:@"支付合计:"];
        NSRange range = NSMakeRange(range1.location+range1.length, hintString.length - range1.location-range1.length);
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];
        label.attributedText = hintString;
        
        
        [view addSubview:label];
       
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.top.mas_offset(0);
            make.height.mas_offset(50);
        }];
        
//        [view addSubview:label1];
//
//        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(label.mas_right);
//            make.top.mas_offset(0);
//            make.height.mas_offset(50);
//        }];
        
//        if ([orderModel.ordertypelabel containsString:@"欠"] || [orderModel.ordertypelabel containsString:@"保"]) {
//
//            label1.text = [NSString stringWithFormat:@"(手续费:%@)",orderModel.service_charge];
//        }else{
//
//        }
       
        
        return bgview;
        
    }else{
        
        _footerView = [[OrderFooterView alloc] initWithFrame:CGRectZero andType:statustr andHasTop:YES type:@"SCOrderListViewController"];
        if ([self.type isEqualToString:@"4"]) {
            bool   ordercommentStatus = [KUserdefaults boolForKey:KordercommentStatus];
            if (ordercommentStatus == YES) {
                _footerView.rightButton.hidden = NO;
            }
        }
        _footerView.delegate = self;
        NSString *iscomment = [NSString stringWithFormat:@"%ld", (long)orderModel.feedback];
        _footerView.statustring = orderModel.orderstatus;
        _footerView.iscomment = iscomment;
        [_footerView refreshButton:iscomment isinvoice:orderModel.isinvoice];
        
        _footerView.rightButton.tag = section + 170;
        _footerView.leftButton.tag = section + 160;
        if ([statustr isEqualToString:@"待发货"]) {
            _footerView.leftButton.hidden = YES;
            _footerView.rightButton.hidden = YES;
        }else if([statustr isEqualToString:@"未付款"]){
            if ([orderModel.ordertypelabel containsString:@"欠"] || [orderModel.ordertypelabel containsString:@"保"]) {
                _footerView.leftButton.hidden = YES;
                _footerView.rightButton.hidden = YES;
            }
        }
        
    
        NSString *allMoney = [NSString stringWithFormat:@"%@", orderModel.ordermoney];
        if (IsNilOrNull(allMoney)) {
            allMoney = @"0.00";
        }
        
        if([statustr isEqualToString:@"已取消"]){
            
        }else{
//            NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)orderModel.itemlistArr.count];
            NSString *str = [NSString stringWithFormat:@"支付合计:¥%@", allMoney];
            
            NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:str];
            //获取要调整颜色的文字位置,调整颜色
            NSRange range1 = [[hintString string]rangeOfString:@"支付合计:"];
            NSRange range = NSMakeRange(range1.location+range1.length, hintString.length - range1.location-range1.length);
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor tt_redMoneyColor] range:range];
            _footerView.priceLable.attributedText = hintString;
        }
        
        

        return _footerView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    SCMyOrderModel *orderModel = self.orderDataArr[section];
    
    NSString *statustr = [NSString stringWithFormat:@"%@",orderModel.orderstatus];
    if ([statustr isEqualToString:@"已付款"] || [statustr isEqualToString:@"退货成功"]){
        return 55;
    }else{
        if ([statustr isEqualToString:@"已取消"]){
            return 55;
        }
        return 55;
    }
}

/**点击进入详情*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCMyOrderModel *orderM = self.orderDataArr[indexPath.section];
    SCOrderDetailVC *checkOrder = [[SCOrderDetailVC alloc] init];
    checkOrder.orderModel = orderM;
    checkOrder.orderstatusString = orderM.orderstatus;
    checkOrder.orderid = orderM.orderId;
    if ([orderM.ordertypelabel containsString:@"欠"]) {
        checkOrder.isqkdd = YES;
    }
    [self.navigationController pushViewController:checkOrder animated:YES];
}

-(void)refreshData {
    __weak typeof(self) weakSelf = self;
    self.orderTableView.mj_header = [MJGearHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.orderTableView.mj_header beginRefreshing];
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
        strongSelf.endInterval = [nowDate timeIntervalSince1970];
        NSTimeInterval value = strongSelf.endInterval - strongSelf.startInterval;
        CGFloat second = [[NSString stringWithFormat:@"%.2f",value] floatValue];//秒
        NSLog(@"间隔------%f秒",second);
        strongSelf.startInterval = strongSelf.endInterval;
        
        RequestReachabilityStatus status = [RequestManager reachabilityStatus];
        switch (status) {
            case RequestReachabilityStatusReachableViaWiFi:
            case RequestReachabilityStatusReachableViaWWAN: {
                if (value >= Interval) {
                    [strongSelf loadMyOrderData:_searchView.searchTextField.text];
                }else{
                    [strongSelf.orderTableView.mj_header endRefreshing];
                }
            }
                break;
            default: {
                [strongSelf showNoticeView:NetWorkNotReachable];
                [strongSelf.orderTableView.mj_header endRefreshing];
            }
            break;
        }
    }];
    
    
    self.orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf loadMoreData];
    }];
}

#pragma mark - 上拉加载更多订单列表数据
-(void)loadMoreData {
    _page ++;
    
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    

        [pramaDic setValuesForKeysWithDictionary:@{@"pageNo":@(_page),@"pageSize":@(KpageSize),@"orderstatus":self.statusString}];
    
    
    
    NSString *orderListUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, GetOrderListUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:orderListUrl params:pramaDic success:^(id json) {
        [self.orderTableView.mj_footer endRefreshing];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self showNoticeView:itemDic[@"message"]];
            return;
        }
        NSArray *itemArr = itemDic[@"data"][@"orderlist"];
        if (itemArr.count == 0) {
            [self.loadingView stopAnimation];
            [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        for (NSDictionary *listOrderDic in itemArr) {
            SCMyOrderModel *orderModel = [[SCMyOrderModel alloc] init];
            [orderModel setValuesForKeysWithDictionary:listOrderDic];
//            orderModel.money = [NSString stringWithFormat:@"%@", listOrderDic[@"money"]];
//            orderModel.ordernumber = [NSString stringWithFormat:@"%@", listOrderDic[@"ordernumber"]];
//            orderModel.iscomment = [NSString stringWithFormat:@"%@", listOrderDic[@"iscomment"]];
//            orderModel.balancemoney = [NSString stringWithFormat:@"%@", listOrderDic[@"balancemoney"]];
            orderModel.statusString = _statusString;
            NSArray *ordersheetArr = listOrderDic[@"ordersheet"];
            if (ordersheetArr.count > 0) {
                
                for (NSInteger i = 0; i<ordersheetArr.count; i++) {
                  
                }
            }
            
            [self.orderDataArr addObject:orderModel];
        }
        
        [self.orderTableView reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.orderTableView.mj_footer endRefreshing];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - FooterViewDelegate
-(void)left0ButtonClick:(UIButton *)btn {
    
   
}


-(void)leftButtonClick:(UIButton *)btn {
    
    SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 160];
    _orderModel = orderM;
    if ([btn.titleLabel.text isEqualToString:@"取消订单"]) {
        [self cancelOrder:orderM];//未付款的可以取消
    }else if ([btn.titleLabel.text isEqualToString:@"删除"]) {
        [self confirmCancelOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        WBWuliuInfoVC  *wuliuVC = [[WBWuliuInfoVC alloc]init];
        wuliuVC.goodSnum = self.orderModel.ordersheet.count;
        wuliuVC.orderid = self.orderModel.orderId;
        [self.navigationController pushViewController:wuliuVC animated:YES];
//        WBWuliuInfoVC *wuluVC = [[WBWuliuInfoVC alloc]init];
//        wuluVC.orderid = orderM.orderId;
//        [self.navigationController pushViewController:wuluVC animated:YES];
    }else if ([btn.titleLabel.text isEqualToString:@"开发票"]){
        SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 160];
        _orderModel = orderM;
        if ([btn.titleLabel.text isEqualToString:@"开发票"]) {
            [self jumpOpenInvoice];
        }
    }
}

-(void)rightButtonClick:(UIButton *)btn {
    SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 170];
    _orderModel = orderM;
    
    if ([btn.titleLabel.text isEqualToString:@"去付款"]) {
        [self payOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"再次购买"]) {
        [self buyAgain:orderM];//再次购买
    }else if ([btn.titleLabel.text isEqualToString:@"联系客服"]) {
        [self contactCS:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"去反馈"]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (SCMyOrderGoodsModel *orderGoodsM in orderM.ordersheet) {
            SCOrderDetailGoodsModel *commentM = [[SCOrderDetailGoodsModel alloc] init];
            commentM.picture = [NSString stringWithFormat:@"%@", orderGoodsM.imgurl];
            commentM.specification = [NSString stringWithFormat:@"%@", orderGoodsM.itemspec];
            commentM.number = [NSString stringWithFormat:@"%@", orderGoodsM.count];
            commentM.name = [NSString stringWithFormat:@"%@", orderGoodsM.name];
            commentM.itemid = [NSString stringWithFormat:@"%@", orderGoodsM.itemid];
            commentM.price = [NSString stringWithFormat:@"%@", orderGoodsM.price];
            commentM.itemno = [NSString stringWithFormat:@"%@", orderGoodsM.itemno];
            [temp addObject:commentM];
        }
        
        if (temp.count > 1) {
            SCWaitReleaseCommentViewController *releaseComment = [[SCWaitReleaseCommentViewController alloc] init];
            releaseComment.orderid = orderM.orderId;
            [self.navigationController pushViewController:releaseComment animated:YES];
        }else if(temp.count == 1){
            SCCommentOrderViewController *releaseComment = [[SCCommentOrderViewController alloc] init];
            releaseComment.orderid = orderM.orderId;
            SCOrderDetailGoodsModel *commentM = temp.firstObject;
            releaseComment.goodsM = commentM;
            [self.navigationController pushViewController:releaseComment animated:YES];
        }else{
            
        }
    }else if ([btn.titleLabel.text isEqualToString:@"查看物流"]) {
        
        NSString *iftransno = [NSString stringWithFormat:@"%@", orderM.logistics];
        if ([iftransno isEqualToString:@"false"] || [iftransno isEqualToString:@"0"] || IsNilOrNull(iftransno)) {
            
        }else{
            WBWuliuInfoVC  *wuliuVC = [[WBWuliuInfoVC alloc]init];
            wuliuVC.goodSnum = self.orderModel.ordersheet.count;
            wuliuVC.orderid = self.orderModel.orderId;
            [self.navigationController pushViewController:wuliuVC animated:YES];
            
//            NSString *oidString = [NSString stringWithFormat:@"%@",_orderModel.orderId];
//            //点击进入物流详情
//            DetailLogisticsViewController *detailLogist = [[DetailLogisticsViewController alloc] init];
//            detailLogist.oidString = oidString;
//            [self.navigationController pushViewController:detailLogist animated:YES];
        }
    }else if ([btn.titleLabel.text isEqualToString:@"差价付款"]) {
        [self payOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"删除"]) {
        [self confirmCancelOrder:orderM];
    }else if ([btn.titleLabel.text isEqualToString:@"开发票"]){
        SCMyOrderModel *orderM = self.orderDataArr[btn.tag - 170];
        _orderModel = orderM;
        if ([btn.titleLabel.text isEqualToString:@"开发票"]) {
            [self jumpOpenInvoice];
        }
    }
}
#pragma mark - 取消订单
-(void)cancelOrder:(SCMyOrderModel *)orderM {
    
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定取消该订单？";
    _deleteAlertView.type = @"取消订单";
    [_deleteAlertView show];
    
}
#pragma mark - 再次购买，跳转到首页
-(void)buyAgain:(SCMyOrderModel *)orderM {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 去付款
-(void)payOrder:(SCMyOrderModel *)orderM {
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", orderM.ordermoney];
    
//    NSString *balancemoney = [NSString stringWithFormat:@"%@", orderM.balancemoney];
//    if (!IsNilOrNull(balancemoney) && [balancemoney doubleValue] > 0) {
//        //补差价
//        payMoney.money = balancemoney;
//    }else{
//        //实付款
//        payMoney.money = [NSString stringWithFormat:@"%@", orderM.money];
//    }
    payMoney.money = orderM.orderpaymoney;
    payMoney.orderid = orderM.orderId;
    NSString *orderNo = [NSString stringWithFormat:@"%@", orderM.orderno];
    if ([orderNo hasPrefix:@"ckdlb"]) {
        payMoney.isdlbitem = @"1";
    }
    [self.navigationController pushViewController:payMoney animated:YES];
}
#pragma mark - 删除订单
-(void)confirmCancelOrder:(SCMyOrderModel *)orderM {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定删除该订单？";
    _deleteAlertView.type = @"删除";
    [_deleteAlertView show];
}

-(void)deleteOrder {
    NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];

    [pramaDic setObject:_orderModel.orderId forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, DelOrderUrl];
    
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
        [self showNoticeView:@"删除成功"];
  
        
        [self loadMyOrderData:_searchView.searchTextField.text];
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

#pragma mark - 确认收货
-(void)confirmReceiveGoods:(SCMyOrderModel *)orderM {
    _deleteAlertView = [[XWAlterVeiw alloc] init];
    _deleteAlertView.delegate = self;
    _deleteAlertView.titleLable.text = @"确定已经收到货物？";
    _deleteAlertView.type = @"确认收货";
    [_deleteAlertView show];
}


-(void)subuttonClicked{
    
    if ([_deleteAlertView.type isEqualToString:@"确认收货"]) {
        [self confirmReceiveGoods];
    }else if ([_deleteAlertView.type isEqualToString:@"取消订单"]) {
        [self confirmCancelOrder];
    }else if ([_deleteAlertView.type isEqualToString:@"删除"]) {
        [self deleteOrder];
    }
}

- (void)payOrder {
    SCOrderDetailModel *orderM = [self.orderDataArr firstObject];
    SCPayViewController *payMoney = [[SCPayViewController alloc] init];
    payMoney.payfeeStr = [NSString stringWithFormat:@"%@", orderM.money];
    
    payMoney.orderid = orderM.orderId;
    NSString *orderNo = [NSString stringWithFormat:@"%@", orderM.orderNo];
    if ([orderNo hasPrefix:@"ckdlb"]) {
        payMoney.isdlbitem = @"1";
    }
    [self.navigationController pushViewController:payMoney animated:YES];
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
        
        NSString *predict = [NSString stringWithFormat:@"orderId = '%@'", _orderModel.orderId];
        
        [self loadMyOrderData:_searchView.searchTextField.text];
        
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

-(void)confirmReceiveGoods {
    NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:_orderModel.orderId forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, ConfirmReceiveUrl];
    
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

        [self loadMyOrderData:_searchView.searchTextField.text];
        
        //  需要跳转到反馈列表
        [CKCNotificationCenter postNotificationName:@"jumpFK" object:@"4"];
        
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 联系客服
-(void)contactCS:(SCMyOrderModel *)orderM {
    [[SobotManager shareInstance] startSobotCustomerService];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)jumpOpenInvoice{
    NSLog(@"跳转开发票");
    InvoicesManagerViewController *manager = [[InvoicesManagerViewController alloc]init];
    [self.navigationController pushViewController:manager animated:YES];
    
}
@end
