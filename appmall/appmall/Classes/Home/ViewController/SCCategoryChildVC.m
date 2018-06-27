//
//  SCCategoryChildVC.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCCategoryChildVC.h"
#import "ZJScrollPageViewDelegate.h"
#import "SCCategoryTableCell.h"
#import "SCCategoryGoodsModel.h"
#import "GoodsDetailViewController.h"
#import "SCDownloadCKAPPWebVC.h"
#import "XWAlterVeiw.h"
#import "RootNavigationController.h"

@interface SCCategoryChildVC ()<ZJScrollPageViewChildVcDelegate, UITableViewDelegate, UITableViewDataSource, CatogoryAddToShoppingCarDelete, XWAlterVeiwDelegate>

@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) UITableView *cateTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy)   NSString *categoryId;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property (nonatomic, assign) BOOL isFirst;
@property (assign ,nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSTimeInterval startInterval;
@property (nonatomic, assign) NSTimeInterval endInterval;

@end

@implementation SCCategoryChildVC

-(NodataLableView *)nodataLableView {
    if(_nodataLableView == nil) {
        _nodataLableView = [[NodataLableView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH,SCREEN_HEIGHT - 64-49-50)];
        _nodataLableView.nodataLabel.text = @"暂无商品";
    }
    return _nodataLableView;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

-(void)passSortIdArray:(id)data {
    
    self.idArr = data;
    self.categoryId = [self.idArr firstObject];
}

-(void)passSelectIndex:(id)data {
    _selectIndex = [data integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initComponents];
    
    [UITableView refreshHelperWithScrollView:self.cateTableView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self loadNewData];
}

-(void)loadNewData{
    _pageNo = 1;
    [self requestData];
}
-(void)zj_viewWillAppearForIndex:(NSInteger)index{
    self.categoryId = self.idArr[index];
    [self loadNewData];
}

-(void)requestData {
    
    _nodataLableView.hidden = YES;
    
    NSString *token = [UserModel getCurUserToken];
    NSDictionary *pramaDic= @{@"appid":Appid,
                                            @"tn":[NSString stringWithFormat:@"%.0f",TN],
                                            @"token":token,
                                            @"pageNo":@(_pageNo),
                                            @"pageSize":@(KpageSize),
                                            @"sortid":self.categoryId
                                            ,@"sortid":self.categoryId};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, Get_Goods_ListBySortid];
    
    NSLog(@"请求参数：%@", pramaDic);
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
      
        if (_pageNo == 1) {
            [self.dataArr removeAllObjects];
        }
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"message"]];
            return ;
        }
        
        NSLog(@"%@", dic);
        NSArray *goodslist = dic[@"data"][@"goodsList"];
        [self.cateTableView tableViewEndRefreshCurPageCount:goodslist.count];
        if (goodslist.count == 0) {
            
            _nodataLableView.hidden = NO;
            [self.dataArr removeAllObjects];
            
            [self.cateTableView reloadData];
            
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
            [self.cateTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            self.dataArr = [NSMutableArray array];
            for (NSDictionary *listDic in goodslist){
                SCCategoryGoodsModel *cateM = [[SCCategoryGoodsModel alloc] initWith:listDic];
                [self.dataArr addObject:cateM];
            }
            
            [self.cateTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        
        [self.cateTableView tableViewEndRefreshCurPageCount:0];
        if (self.dataArr.count == 0) {
            _nodataLableView.hidden = NO;
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        if(self.dataArr.count == 0){
            _nodataLableView.hidden = NO;
            [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
    }];
}

-(void)initComponents {
    _cateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-NaviAddHeight-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_cateTableView];
    
    self.cateTableView.estimatedSectionHeaderHeight = 0;
    self.cateTableView.estimatedSectionFooterHeight = 0;
    self.cateTableView.delegate = self;
    self.cateTableView.dataSource = self;
    [self.cateTableView registerNib:[UINib nibWithNibName:@"SCCategoryTableCell" bundle:nil] forCellReuseIdentifier:@"SCCategoryTableCell"];
    _cateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SCCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCategoryTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr.count > 0) {
        [cell refreshCellWithModel:self.dataArr[indexPath.row]];
    }else{
        [self.cateTableView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AdaptedWidth(130);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
    detailVC.goodsM = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    [self presentViewController:welcomeNav animated:YES completion:nil];
}

#pragma mark - 添加到购物车
-(void)addGoodsToShoppingCar:(SCCategoryGoodsModel *)cateM {
    
    if ([[KUserdefaults objectForKey:KloginStatus] boolValue] == NO) {
        [self goWelcom];
        return;
    }
    NSString *isdlbitem = @"";
    if ([isdlbitem isEqualToString:@"true"] || [isdlbitem isEqualToString:@"1"]) {
        //跳转到下载下载创客app页面
        XWAlterVeiw *alert = [[XWAlterVeiw alloc] init];
        alert.delegate = self;
        alert.titleLable.text = @"您购买的商品暂不能在商城下单，请点击【确定】下载创客APP进行购买";
        [alert show];
    }else{
        
        NSLog(@"加入购物车");
        
        NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
         NSString* itemsStr  = [@[@{@"itemid":cateM.itemid,@"num":@"1"}] mj_JSONString];
        [pramaDic setObject:itemsStr forKey:@"items"];
        NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddToShoppingCarUrl];
        
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
        
        [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
            [self.loadingView stopAnimation];
            NSDictionary *dic = json;
            NSString * status = [dic valueForKey:@"code"];
            if ([status intValue] != 200) {
                [self showAddShoppingNoticeViewIsSuccess:NO andTitle:nil];
                return ;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"AddToShoppingCarSuccess" forKey:@"SCChangedShopingCar"];
            [self showAddShoppingNoticeViewIsSuccess:YES andTitle:nil];
        } failure:^(NSError *error) {
            [self.loadingView stopAnimation];
            if (error.code == -1009) {
                [self showNoticeView:NetWorkNotReachable];
            }else{
                [self showNoticeView:NetWorkTimeout];
            }
        }];
    }
}

-(void)subuttonClicked {
    SCDownloadCKAPPWebVC *downVC = [[SCDownloadCKAPPWebVC alloc] init];
    [self.navigationController pushViewController:downVC animated:YES];
}


-(void)loadMoreData {
    _pageNo ++;
    [self requestData];
}

- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    [self.cateTableView.mj_header endRefreshing];
    [self.cateTableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
