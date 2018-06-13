//
//  HonourDetailViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HonourDetailViewController.h"
#import "HonorListModel.h"
#import "HonourListViewCell.h"
#import "ImageDetailController.h"
#define KHonourListViewCell @"HonourListViewCell"

@interface HonourDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)NSMutableArray <HonorListModel *> *dataList;
@property (weak, nonatomic) IBOutlet UITableView *honourDetailList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBottomDis;
@property (assign, nonatomic)  NSInteger page;
@end

@implementation HonourDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page  =1;
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabTopDis.constant = NaviHeight;
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    [UITableView refreshHelperWithScrollView:_honourDetailList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:YES];
    [self setTableView];
    self.title = @"企业荣誉";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    [self requestDataWithoutCache];
    
}
-(void)loadNewData{
    _page = 1;
    [self requestDataWithoutCache];
}

-(void)loadMoreData{
    _page ++;
    [self requestDataWithoutCache];
}


-(void)setTableView{
    self.tabTopDis.constant = NaviHeight;
    self.tabBottomDis.constant = BOTTOM_BAR_HEIGHT;
    self.honourDetailList.delegate = self;
    self.honourDetailList.dataSource = self;
    [self.honourDetailList registerNib:[UINib nibWithNibName:KHonourListViewCell bundle:nil] forCellReuseIdentifier:KHonourListViewCell];
    [self .honourDetailList reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HonourListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHonourListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    [cell reloadDataModel: [self.dataList objectAtIndex:indexPath.row]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageDetailController *imageDetailVC = [[ImageDetailController alloc]init];
    imageDetailVC.imgUrl = self.dataList[indexPath.row].imgpath;
    [self presentViewController:imageDetailVC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabReloadData{
    
    [self.honourDetailList reloadData];
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tabTopDis.constant = NaviHeight;
        _tabBottomDis .constant = BOTTOM_BAR_HEIGHT;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        _tabTopDis.constant = NaviHeight + 44;
    });
}

-(void)requestDataWithoutCache {
    [self loadHomeData:YES];
}

-(void)loadHomeData:(BOOL)showLoading {
    
    NSDictionary *pramaDic= @{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":@"",@"pageNo":@(_page),@"pageSize":@(KpageSize),@"sign":[RequestManager getSignNSDictionary:@{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":@""} andNeedUrlEncode:YES andKeyToLower:YES]};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Home_HonorList_Url];
    
    if (showLoading) {
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
    }
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.honourDetailList.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return ;
        }

        NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
        if (!IsNilOrNull(meid)) {
            // 设置标签，别名
            NSSet *setTags = [NSSet setWithObject:@"appmall"];
            //            [JPUSHService setTags:setTags alias:[NSString stringWithFormat:@"m%@", meid] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            //                NSLog(@"\n[用户登录成功后设置别名]---[%@]",iAlias);
            //            }];
            
            //查看registId
            //            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            //                NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
            //            }];
        }
        
        if (dic != nil) {  //请求到数据
            NSArray *countList =dic[@"data"][@"honorList"];
            [_honourDetailList tableViewEndRefreshCurPageCount:0];
            if(_page == 1){
                [self.dataList removeAllObjects];
            }
            for (NSDictionary *itemDic  in dic[@"data"][@"honorList"]) {
                [self.dataList addObject:[[HonorListModel alloc]initWith:itemDic]];
            }
        }else{
            [_honourDetailList.mj_header endRefreshing];
            [_honourDetailList.mj_footer endRefreshing];
        }
        [self.honourDetailList reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        [self.honourDetailList.mj_header endRefreshing];
    }];
}


@end
