//
//  HomeViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HomeViewController.h"
#import "MedieaDetailViewController.h"
#import "DWQSearchController.h"
#import "WBAdsImgView.h"
#import "RecommendViewCell.h"
#import "HonourDetailViewController.h"
#import "MessageViewController.h"
#import "SCCategoryViewController.h"
#import "MedieaListViewController.h"
#import "TKHomeDataModel.h"
#import "HomeTabTopAdsViewCell.h"
#define KRecommendViewCell @"RecommendViewCell"
#define KHomeTabTopAdsViewCell  @"HomeTabTopAdsViewCell"
@interface HomeViewController ()<WBAdsImgViewDelegate,UITableViewDelegate,UITableViewDataSource,RecommendViewCellDelegate>
{
    TKHomeDataModel *model;
    __weak IBOutlet NSLayoutConstraint *tabDisBottom;
    __weak IBOutlet NSLayoutConstraint *tabDisTop;

    WBAdsImgView *adsView;

    CGFloat curY;
    UIView  *menuView;

    __weak IBOutlet UITableView *tabHomeList;
    
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        MJWeakSelf;
    self.token = [self.realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        [weakSelf tabReloadData];
    }];

    [self creatSearchUI];
    [self creatRightItem];
    
    [self setTableView];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    [self requestDataWithoutCache];
    
}


-(void)tabReloadData{
    RLMResults *result = [TKHomeDataModel allObjectsInRealm:self.realm];
    model = [result firstObject];
    [tabHomeList reloadData];
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        tabDisTop.constant = NaviHeight;
        tabDisBottom .constant = BOTTOM_BAR_HEIGHT + 49;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        tabDisTop.constant = NaviHeight + 44;
    });
    

}

-(void)requestDataWithoutCache {
    [self loadHomeData:YES];
}

-(void)loadHomeData:(BOOL)showLoading {
    
    NSDictionary *pramaDic= @{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":@"",@"sign":[RequestManager getSignNSDictionary:@{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":@""} andNeedUrlEncode:YES andKeyToLower:YES]};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Home_Url];
    
    if (showLoading) {
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
    }
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [tabHomeList.mj_header endRefreshing];
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
            TKHomeDataModel * homeData = [[TKHomeDataModel alloc]initWith:dic[@"data"]];
            homeData.modelId = @"1";
            [self.realm beginWriteTransaction];
            [self.realm addOrUpdateObject:homeData];
            [self.realm commitWriteTransaction];
        }
        RLMResults *result = [TKHomeDataModel allObjectsInRealm:self.realm];
        model = [result firstObject];
        [tabHomeList reloadData];

    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        [tabHomeList.mj_header endRefreshing];
    }];
}

-(void)setTableView{
    tabHomeList.delegate = self;
    tabHomeList.dataSource = self;
    [tabHomeList registerNib:[UINib nibWithNibName:KRecommendViewCell bundle:nil] forCellReuseIdentifier:KRecommendViewCell];
    [tabHomeList registerClass:[HomeTabTopAdsViewCell class] forCellReuseIdentifier:KHomeTabTopAdsViewCell   ];
    [tabHomeList reloadData];
}

#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        HomeTabTopAdsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeTabTopAdsViewCell];
        [cell  loadData:model];
        return cell;
    }else{
        RecommendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
        [cell setCollection:indexPath.section andData:model];
        cell.delegate = self;
        
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        RecommendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
    return [cell getCollectionHeight:indexPath.section];
    
}

-(void)adsImgViewClick:(BannerModel*)itemIndex{
    
}

-(void)creatSearchUI{
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = CGRectMake(0, 0, KscreenWidth - 80, 30);
    [itemBtn setImage:[UIImage imageNamed:@"搜索"] forState:0];
    [itemBtn setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    itemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [itemBtn setTitle:@"搜索商品 " forState:0];
    [itemBtn setBackgroundColor:RGBCOLOR(230 , 230, 230)];
    itemBtn .layer.cornerRadius = 3;
    itemBtn.layer.masksToBounds = YES;
    [itemBtn addTarget:self  action:@selector(actionSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = itemBtn;
}

-(void)creatRightItem{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UILabel *numMsg = [[UILabel alloc]initWithFrame:CGRectMake(28, 0, 13, 13)];
    numMsg.text = @"2";
    numMsg.textAlignment = NSTextAlignmentCenter;
    numMsg .font = [UIFont systemFontOfSize:8];
    numMsg.textColor = [UIColor whiteColor];
    numMsg.backgroundColor = [UIColor redColor];
    numMsg.layer .cornerRadius = 5;
    numMsg.layer.masksToBounds = YES;
    [rightView addSubview:numMsg];
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn addTarget:self action:@selector(actionToMessage) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.frame = CGRectMake(10, 10, 25, 25);
    [itemBtn setBackgroundImage:[UIImage imageNamed:@"消息图标"] forState:0];
    [rightView addSubview:itemBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)actionSearch{
    DWQSearchController *dwqSearch=[[DWQSearchController alloc]init];
    dwqSearch.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:dwqSearch animated:NO];
}
#pragma HomeMenuItemViewDelegate
-(void)itemClick:(NSInteger)index{
    
}

#pragma recommendViewCellDelegateMore

-(void)recommendViewCellDelegateMore:(NSInteger)index{
    HonourDetailViewController *honourVC = [[HonourDetailViewController alloc]init];
     MedieaListViewController*medieaVC = [[MedieaListViewController alloc]init];
  
    switch (index) {
            
        case 2:
            [self actionGoto];
            break;
        case 3:
            medieaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:medieaVC animated:YES];
            
            break;
        case 4:
            honourVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:honourVC animated:YES];
            break;
            
        default:
            break;
    }
}


-(void)actionGoto{
    NSString *token = [UserModel getCurUserToken];
    NSDictionary *pramaDic= @{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":token,@"sign":[RequestManager getSignNSDictionary:@{@"appid":Appid,@"tn":[NSString stringWithFormat:@"%.0f",TN],@"token":token} andNeedUrlEncode:YES andKeyToLower:YES]};
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Home_Goods_Class_Url];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [tabHomeList.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        
        NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
        if (!IsNilOrNull(meid)) {
            
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
            SCCategoryViewController *category = [[SCCategoryViewController alloc]init];
            NSArray *categoryList = dic[@"data"][@"categoryList"];
            for(int i = 0; i < 10; i++){
                NSDictionary * itemDic = [categoryList objectAtIndex:0];
                category.titleArr = [NSMutableArray arrayWithCapacity:0];
                [category.titleArr addObject:itemDic[@"name"]];
                category.categoryIdArr = [NSMutableArray arrayWithCapacity:0];
                [category.categoryIdArr addObject:itemDic[@"styleid"]];
                category.selectedIndex = 0;
            }
          [self.navigationController pushViewController:category animated:YES];
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)recommendViewCellClick:(NSIndexPath *)indexpath andTabIndex:(NSInteger)index{
    if(index == 3){
        
        MedieaDetailViewController *medieaDetailVC = [[MedieaDetailViewController alloc]init];
        medieaDetailVC.strUrl = model.mediaList[indexpath.row].link;
        medieaDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:medieaDetailVC animated:YES];
        
    }
}

-(void)loadData{
    NSDictionary *dic = [self readLocalFileWithName:@"HomeJson"]; // 模拟网络请求
    if (dic != nil) {  //请求到数据
        TKHomeDataModel * homeData = [[TKHomeDataModel alloc]initWith:dic];
        homeData.modelId = @"1";
        [self.realm beginWriteTransaction];
        [self.realm addOrUpdateObject:homeData];
        [self.realm commitWriteTransaction];
    }
    RLMResults *result = [TKHomeDataModel allObjectsInRealm:self.realm];
    model = [result firstObject];
    [tabHomeList reloadData];
}

-(void)actionToMessage{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}
@end
