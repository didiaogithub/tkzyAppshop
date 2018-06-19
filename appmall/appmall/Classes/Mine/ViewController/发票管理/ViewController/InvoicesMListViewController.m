//
//  InvoicesMListViewController.m
//  appmall
//
//  Created by majun on 2018/6/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesMListViewController.h"
#import "InvoicesManagerHeadView.h"
#import "InvoicesManagerCell.h"
#import "InvoicesManagerDetailVC.h"
#import "OpenInvoicesViewController.h"
#import "InvoicesManagerModel.h"
#import "InvoicesManCellHeadView.h"
#import "InvoicesManCellFooterView.h"
#import "AddInvoicesDataViewController.h"
#import "MyInvoicesViewController.h"
#import "Ordersheet.h"
@interface InvoicesMListViewController ()<UITableViewDelegate,UITableViewDataSource,InvoicesManCellFooterViewDelegate,XYTableViewDelegate>
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
/**  pageNo*/
@property (nonatomic, assign)  NSInteger page;

@end

@implementation InvoicesMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    _page = 1;
    [self.mTableView registerNib:[UINib nibWithNibName:@"InvoicesManagerCell" bundle:nil] forCellReuseIdentifier:@"InvoicesManagerCell"];
    [self initComponments];
    [UITableView refreshHelperWithScrollView:self.mTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];

}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"发票无"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无此类发票哦";
    return str;
}
-(void)loadNewData{
    _page =  1;
    if (self.selectFirstState == YES) {
        [self getData:@"0"];
    }else{
        [self getData:@"1"];
    }
}

-(void)loadMoreData{
    _page ++;
    if (self.selectFirstState == YES) {
        [self getData:@"0"];
    }else{
        [self getData:@"1"];
    }
}


- (void)getData:(NSString*)type{
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:type forKey:@"invoice"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getOrderByInvoiceApi];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.mTableView.mj_header endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.mTableView tableViewEndRefreshCurPageCount:0];
            [self showNoticeView:dict[@"message"]];
        }
        
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *Arr = dict[@"data"];
        [self.mTableView tableViewEndRefreshCurPageCount:Arr.count];
        for (NSDictionary *dic in Arr) {
            InvoicesManagerModel *model = [[InvoicesManagerModel alloc]initWithDictionary:dic];
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


- (void)initComponments{
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - (64 + AdaptedHeight(127) + 45 + 10)) style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.view addSubview:self.mTableView];
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
    
    return 81;
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
    InvoicesManCellHeadView *view = [[InvoicesManCellHeadView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    InvoicesManagerModel *model = self.dataArray[section];
    view.orderNum.text = [NSString stringWithFormat:@"订单编号:%@",model.orderno];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    InvoicesManCellFooterView *view = [[InvoicesManCellFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,46)];
    InvoicesManagerModel *model = self.dataArray[section];
    view.rightBtn.layer.masksToBounds = YES;
    view.rightBtn.layer.cornerRadius = 3;
    view.rightBtn.layer.borderColor = [UIColor redColor].CGColor;
    view.rightBtn.layer.borderWidth = 1;
    view.delegate = self;
    view.labRight.hidden = YES;
    view.rightBtn.tag = section;
    //        0-未开票，1-申请中，2-申请拒绝，3-开票中，4-开票成功，5-开票失败
    if (self.selectFirstState == YES) {
        [view.rightBtn setTitle:@"开发票" forState:0];
        if ( model.disposestatus ==0 || model.disposestatus == 2) { // 0-未开票 2-申请拒绝 显示开发票按钮
            view.rightBtn.hidden = NO;
        }else{ // 1-申请中 隐藏开发票按钮
            view.rightBtn.hidden = YES;
            view.labRight.hidden = NO;
            view.labRight.text = @"申请中";
        }
        
    }else{
        [view.rightBtn setTitle:@"发票详情" forState:0];
        if ( model.disposestatus == 4) { // 4-开票成功
            view.rightBtn.hidden = NO;
        }else{ // 1-申请中 隐藏开发票按钮
            view.rightBtn.hidden = YES;
            view.labRight.hidden = NO;
            if (model.disposestatus == 3) {
                view.labRight.text = @"开票中";
            }else if(model.disposestatus == 5){
                view.labRight.text = @"开票失败";
            }
            
        }
        
    }
    
    
    
    
    view.orderTimeLab.text = [NSString stringWithFormat:@"下单时间：%@",model.ordertime];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}


- (void)showDetail:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:@"开发票"]) {
        
        OpenInvoicesViewController *open = [[OpenInvoicesViewController alloc]init];
        InvoicesManagerModel *model = self.dataArray[sender.tag];
        if (model.invoice == 0) { // 0 是没有审核审核成功的发票模板 需要去添加
            //            AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
            //            [self.navigationController pushViewController:add animated:YES];
            [self showNoticeView:@"请点击开票信息，去添加发票模板"];
        }else{ // 1是有 可以直接跳转到详情那个页面
            open.orderno = model.orderno;
            open.orderid = model.orderid;
            [self.navigationController pushViewController:open animated:YES];
        }
    }else{
        InvoicesManagerDetailVC *detail = [[InvoicesManagerDetailVC alloc]init];
        InvoicesManagerModel *model = self.dataArray[sender.tag];
        detail.orderid = model.orderid;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}
@end
