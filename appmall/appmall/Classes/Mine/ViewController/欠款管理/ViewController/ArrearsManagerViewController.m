//
//  ArrearsManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsManagerViewController.h"
#import "ArrearsTableCell.h"
#import "ArrearsFooterView.h"
#import "ArrearsHeaderView.h"
#import "arrearsModel.h"
#import "SCPayViewController.h"
@interface ArrearsManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ArrearsFooterViewDelegate>
{
    NSArray *titleArr;
}
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) NSMutableArray *orderDataArr;
@property (nonatomic, strong) UIButton *applyingButton; //申请中
@property (nonatomic, strong) UIButton *refusedButton; //已拒绝
@property (nonatomic, strong) UIButton *waitPayButton; //待还款
@property (nonatomic, strong) UIButton *afterPayButton; //已还款
@property (nonatomic, strong) NSMutableArray *statusBtnArr;
@property (nonatomic, strong) UILabel *indicateLine;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, copy)  NSString *statusString;
@property (assign,nonatomic)NSInteger page;
/**  dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**  tableView*/
@property (nonatomic, strong) UITableView *mTableView;
@end

@implementation ArrearsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欠款管理";
    self.statusString = @"1";
    _statusArr = @[@"1", @"2", @"3", @"4"];
     [self createTopButton];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    _page = 1;
    [self initComponments];
    [UITableView refreshHelperWithScrollView:self.mTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
}

-(void)loadNewData{
    _page =  1;
    [self getData:self.statusString];
}

-(void)loadMoreData{
    _page ++;
   [self getData:self.statusString];
}
- (void)initComponments{
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 64  + 45 + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
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


/**创建订单状态按钮*/
-(void)createTopButton{
    self.statusView = [[UIView alloc] init];
    self.statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    float buttonH = 50;
    _statusBtnArr = [NSMutableArray array];
    titleArr = @[@"申请中", @"已拒绝", @"待还款", @"已还款"];
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [self createOrderButtonWithframe:CGRectMake((SCREEN_WIDTH/4)*i, 0, SCREEN_WIDTH/4, buttonH) andTag:140+i andAction:@selector(clickOrderButton:) andtitle:titleArr[i]];
        [self.statusView addSubview:btn];
        [_statusBtnArr addObject:btn];
    }
    
    self.indicateLine = [[UILabel alloc] init];
    self.indicateLine.backgroundColor = [UIColor tt_redMoneyColor];
    [self.statusView addSubview:self.indicateLine];
    [self.indicateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(47);
        make.left.mas_offset(20);
        make.width.mas_offset(SCREEN_WIDTH/4 - 40);
        make.height.mas_offset(3);
    }];
    
}

/**创建 统一 button*/
-(UIButton *)createOrderButtonWithframe:(CGRect)frame andTag:(NSInteger)tag andAction:(SEL)action andtitle:(NSString *)title{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TitleColor forState:UIControlStateNormal];
    button.titleLabel.font = MAIN_TITLE_FONT;
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    switch (tag-140) {
        case 0:
            _applyingButton = button;
            break;
        case 1:
            _refusedButton = button;
            break;
        case 2:
            _waitPayButton = button;
            break;
        case 3:
            _afterPayButton = button;
            break;
        default:
            break;
    }
    
    return button;
}


-(void)clickOrderButton:(UIButton *)button{
  
    
    [self updateBtnSelectedState:button];
}
-(void)updateBtnSelectedState:(UIButton*)button {
    for (NSInteger i = 0; i < _statusBtnArr.count; i++) {
        UIButton *btn = _statusBtnArr[i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    self.statusString = _statusArr[button.tag - 140];
    [self moveStatusLineWithStatus:self.statusString];
    button.selected = YES;
    [button setUserInteractionEnabled:NO];
}


//移动红线
-(void)moveStatusLineWithStatus:(NSString *)status{
    
    
    float leftX = 20;
    if ([self.statusString isEqualToString:@"1"]){//申请中
        leftX = 20;
    }else if ([self.statusString isEqualToString:@"2"]){//已拒绝
        leftX = SCREEN_WIDTH/4 + 20;
    }else if ([self.statusString isEqualToString:@"3"]){//已还款
        leftX = SCREEN_WIDTH*2/4 + 20;
    }else{ //4:全部
        leftX = SCREEN_WIDTH*3/4 + 20; // 待还款
    }
    [self.indicateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftX);
    }];
    [self loadNewData];
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
    
    return 90;
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
    ArrearsHeaderView *view = [[ArrearsHeaderView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    arrearsModel *model = self.dataArray[section];
    view.orderNo.text = [NSString stringWithFormat:@"订单编号:%@",model.no];
    int status = [self.statusString intValue];
    view.orderStates.text = titleArr[status - 1];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ArrearsFooterView *view = [[ArrearsFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.delegate = self;
    view.leftBtn.tag = section;
    view.rightBtn.tag = section;
    arrearsModel  * model = self.dataArray[section];
    view.orderTotal.text = [NSString stringWithFormat:@"合计：¥%@",model.ordermoney];
   
    return view;
}

- (void)leftBtnAction:(UIButton *)sender{
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    arrearsModel  * model = self.dataArray[sender.tag];
//    [pramaDic setObject:model.orderid forKey:@"orderid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, CancelOrderUrl];
    
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
    

//    payMoney.orderid = orderM.orderId;
//    NSString *orderNo = [NSString stringWithFormat:@"%@", model.orderno];
//    if ([orderNo hasPrefix:@"ckdlb"]) {
//        payMoney.isdlbitem = @"1";
//    }
    [self.navigationController pushViewController:payMoney animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}



@end
