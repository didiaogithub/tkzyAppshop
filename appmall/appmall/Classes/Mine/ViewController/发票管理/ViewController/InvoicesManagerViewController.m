//
//  InvoicesManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerViewController.h"
#import "InvoicesManagerHeadView.h"
#import "InvoicesManagerCell.h"
#import "InvoicesManagerDetailVC.h"
#import "OpenInvoicesViewController.h"
#import "InvoicesManagerModel.h"
#import "InvoicesManCellHeadView.h"
#import "InvoicesManCellFooterView.h"
#import "Ordersheet.h"
#define leftTag 2000
#define rightTag 2001
@interface InvoicesManagerViewController ()<UITableViewDelegate,UITableViewDataSource,InvoicesManCellFooterViewDelegate>

/**  headView*/
@property (nonatomic, strong) InvoicesManagerHeadView *headView;
@property (nonatomic,strong) UIView *sliderView;//标题栏上的滑动线
@property (nonatomic,strong) NSMutableArray *segementArr;//导航栏上的按钮数组
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentIndex;
/**  是否选中第一个按钮*/
@property (nonatomic, assign) BOOL selectFirstState;

@property (nonatomic,strong) UITableView *mTableView;
@end

@implementation InvoicesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票管理";
    self.dataArray = [NSMutableArray array];
    self.headView = [[InvoicesManagerHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT * 0.15)];
    [self.view addSubview:self.headView];
    
     [self setSegamentView];
     [self.mTableView registerNib:[UINib nibWithNibName:@"InvoicesManagerCell" bundle:nil] forCellReuseIdentifier:@"InvoicesManagerCell"];
    
    [self initComponments];
    self.selectFirstState = YES;
    
    [self getData:@"0"];
}

- (void)getData:(NSString*)type{
    NSString *token = [UserModel getCurUserToken];
    NSDictionary * pramaDic = @{@"appid":Appid,
                                @"tn":[NSString stringWithFormat:@"%.0f",TN],
                                @"token":@"df9e345e28349f5911a413026924f63c",
                                @"pageNo":@"1",
                                @"pageSize":@"10",
                                @"invoice":type,
                                @"sign":[RequestManager getSignNSDictionary:@{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":@"df9e345e28349f5911a413026924f63c",@"pageNo":@"1",
                                                                              @"pageSize":@"10",@"invoice":type} andNeedUrlEncode:YES andKeyToLower:YES]};
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getOrderByInvoiceApi];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSArray *Arr = dict[@"data"];
        for (NSDictionary *dic in Arr) {
            InvoicesManagerModel *model = [[InvoicesManagerModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        
        }
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}

- (void)initComponments{
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, 64 + SCREEN_HEIGHT *0.15 + 45 + 10, SCREEN_WIDTH, SCREEN_HEIGHT - (64 + SCREEN_HEIGHT *0.15 + 45 + 10)) style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
}

- (void)setSegamentView
{
    CGFloat Space = 20;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + SCREEN_HEIGHT *0.15 + 10, SCREEN_WIDTH , 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    CGFloat contentViewW = contentView.frame.size.width;
    CGFloat btnW = (contentViewW -  Space)/2;
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , btnW, 35)];
    [button setTitle:@"待开发票" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    button.selected = YES;
    button.tag = leftTag;
    [contentView addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(Space + btnW, 0 , btnW, 35)];
    [button1 setTitle:@"已开发票" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:12];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [contentView addSubview:button1];
    button1.tag = rightTag;
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.segementArr = [NSMutableArray arrayWithObjects:button,button1,nil];
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake((btnW - 50)/2 , 39,50, 1)];
    self.sliderView.backgroundColor = [UIColor redColor];
    [contentView addSubview:self.sliderView];
    self.currentIndex = 0;
    [self.view addSubview:contentView];
    
}

//导航栏切换
- (void)buttonClick:(UIButton *)sender
{
    
    if (sender.tag == leftTag) { // 待开发票
       self.selectFirstState = YES;
        
    }
    else if (sender.tag == rightTag) // 已开发票
    {
         self.selectFirstState = NO;
       
    }
    [self.mTableView reloadData];
    self.sliderView.x = sender.x + (sender.width - 50)/2;
    self.sliderView.width = 50;
    
    for (UIButton *btn in self.segementArr) {
        btn.selected = NO;
    }
    UIButton * btn1 = self.segementArr[sender.tag - 2000];
    btn1.selected = YES;
}



#pragma mark ---- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    InvoicesManagerModel *model = self.dataArray[section];
    
    return model.ordersheet.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InvoicesManagerCell";//这个identifier跟xib设置的一样
    InvoicesManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]
                loadNibNamed:@"InvoicesManagerCell" owner:self options:nil]  lastObject];
    }
    InvoicesManagerModel *model = self.dataArray[indexPath.section];
    NSArray *ordersheet = model.ordersheet;
    [cell refreshData:ordersheet[indexPath.row]];
 
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    InvoicesManCellHeadView *view = [[InvoicesManCellHeadView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    InvoicesManagerModel *model = self.dataArray[section];
    view.orderNum.text = [NSString stringWithFormat:@"订单编码:%@",model.orderno];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    InvoicesManCellFooterView *view = [[InvoicesManCellFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,50)];
    view.rightBtn.layer.masksToBounds = YES;
    view.rightBtn.layer.cornerRadius = 3;
    view.rightBtn.layer.borderColor = [UIColor redColor].CGColor;
    view.rightBtn.layer.borderWidth = 1;
    view.delegate = self;
    view.tag = section;
    if (self.selectFirstState == YES) {
        [view.rightBtn setTitle:@"开发票" forState:0];
        
    }else{
        [view.rightBtn setTitle:@"发票详情" forState:0];
    }
    
    InvoicesManagerModel *model = self.dataArray[section];
    view.orderTimeLab.text = [NSString stringWithFormat:@"订单时间：%@",model.ordertime];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (void)showDetail:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"开发票"]) {
        OpenInvoicesViewController *open = [[OpenInvoicesViewController alloc]init];
        InvoicesManagerModel *model = self.dataArray[sender.tag];
        open.invoiceid = model.orderid;
        [self.navigationController pushViewController:open animated:YES];
    }else{
        InvoicesManagerDetailVC *detail = [[InvoicesManagerDetailVC alloc]init];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
@end
