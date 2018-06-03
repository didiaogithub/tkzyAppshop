//
//  MyInvoicesViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MyInvoicesViewController.h"
#import "MyInvoicesCell.h"
#import "MyinvoicesCheckingCell.h"
#import "MyInvoicesCheckFailCell.h"
#import "AddInvoicesDataViewController.h"
#import "MyInvoicesModel.h"
@interface MyInvoicesViewController ()<UITableViewDataSource,UITableViewDelegate,MyInvoicesCellDelegate,MyInvoicesCheckFailCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)addinvoicesDataAction:(UIButton *)sender;
/**  data*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**  未处理*/
@property (nonatomic, strong) NSMutableArray *wclDataArray;
/**  已处理*/
@property (nonatomic, strong) NSMutableArray <MyInvoicesModel *>*yclDataArray;
/**  已拒绝*/
@property (nonatomic, strong) NSMutableArray *yjjDataArray;

/**  pageNo*/
@property (nonatomic, assign)  NSInteger page;

@end

@implementation MyInvoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的发票";
    self.dataArray = [NSMutableArray array];
    self.yjjDataArray = [NSMutableArray array];
    self.wclDataArray = [NSMutableArray array];
    self.yclDataArray = [NSMutableArray array];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyinvoicesCheckingCell" bundle:nil] forCellReuseIdentifier:@"MyinvoicesCheckingCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCheckFailCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCheckFailCell"];
    self.mTableView.tableFooterView = [UIView new];
    
    _page = 1;
    [UITableView refreshHelperWithScrollView:self.mTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];    
}


-(void)loadNewData{
    _page =  1;
    [self getData];
}

-(void)loadMoreData{
    _page ++;
    [self getData];
}

- (void)getData{
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:@"df9e345e28349f5911a413026924f63c" forKey:@"token"]; // 目前是测试，正式上删除
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMyInvoiceApi];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.mTableView.mj_header endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.mTableView tableViewEndRefreshCurPageCount:0];
            [self showNoticeView:dict[@"message"]];
        }
        
        if (self.page == 1) {
            [self.wclDataArray removeAllObjects];
            [self.yclDataArray removeAllObjects];
            [self.yjjDataArray removeAllObjects];
        }
        NSArray *Arr = dict[@"data"][@"invoices"];
        [self.mTableView tableViewEndRefreshCurPageCount:Arr.count];
        for (NSDictionary *dic in Arr) {
            MyInvoicesModel *MyInvoicesM = [[MyInvoicesModel alloc] init];
            [MyInvoicesM setValuesForKeysWithDictionary:dic];
            
            if ([MyInvoicesM.disposestatus isEqualToString:@"0"]) {
                [self.wclDataArray addObject:MyInvoicesM];
            }else if ([MyInvoicesM.disposestatus isEqualToString:@"1"]){
                [self.yclDataArray addObject:MyInvoicesM];
                 [self.yclDataArray firstObject].isSelect = YES;
            }else{
                [self.yjjDataArray addObject:MyInvoicesM];
            }
            
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tcell;
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"MyInvoicesCell";//这个identifier跟xib设置的一样
        MyInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCell" owner:self options:nil]  lastObject];
        }
         cell.delegate = self;
         cell.selectBtn.selected = self.yclDataArray[indexPath.row].isSelect;
        [cell refreshData:self.yclDataArray[indexPath.row]];
       
        
        tcell = cell;
    }else if (indexPath.section == 1){
        static NSString *identifier = @"MyinvoicesCheckingCell";//这个identifier跟xib设置的一样
        MyinvoicesCheckingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyinvoicesCheckingCell" owner:self options:nil]  lastObject];
        }
        [cell refreshData:self.wclDataArray[indexPath.row]];
         tcell = cell;
        
    }else{
        static NSString *identifier = @"MyInvoicesCheckFailCell";//这个identifier跟xib设置的一样
        MyInvoicesCheckFailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCheckFailCell" owner:self options:nil]  lastObject];
        }
        cell.delegate = self;
        [cell refreshData:self.yjjDataArray[indexPath.row]];
         tcell = cell;
        
        
    }
   
    return tcell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.yclDataArray.count;
    }else if(section == 1){
        return self.wclDataArray.count;
    }else{
        return self.yjjDataArray.count;
    }
    return 0;
}

- (void)tableCellButtonDidSelected:(MyInvoicesModel *)model{
    for (MyInvoicesModel *itemModel in self.yclDataArray) {
        itemModel.isSelect = NO;
    }
    model.isSelect = YES;
    [self.mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    view.backgroundColor = [UIColor tt_lineBgColor];
    UILabel *type = [UILabel new];
    type.frame = CGRectMake(15,10, SCREEN_WIDTH, 20);
    type.font = [UIFont systemFontOfSize:14];
    type.text = @"审核中";
    if (section == 2) {
       type.text = @"审核失败";
        type.textColor = [UIColor redColor];
    }
    
    [view addSubview:type];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor tt_lineBgColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 2) {
        return 136;
    }
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
           return 10;
    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addinvoicesDataAction:(UIButton *)sender {
    
    AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    MyInvoicesModel *model = self.wclDataArray[indexPath.row];
//    self.selectMyInvoicesBlock(model);
}

-(void)jumpAddInvoicesDataViewController{
    AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

@end
