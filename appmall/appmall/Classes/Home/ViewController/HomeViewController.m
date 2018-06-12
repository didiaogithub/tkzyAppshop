//
//  HomeViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HomeViewController.h"
#import "MedieaDetailViewController.h"
#import "RootNavigationController.h"
#import "DWQSearchController.h"
#import "WBAdsImgView.h"
#import "RecommendViewCell.h"
#import "HonourDetailViewController.h"
#import "MessageViewController.h"
#import "SCCategoryViewController.h"
#import "MedieaListViewController.h"
#import "TKHomeDataModel.h"
#import "HomeTabTopAdsViewCell.h"
#import "SCOrderDetailModel.h"
#import "GoodsDetailViewController.h"
#define KRecommendViewCell @"RecommendViewCell"
#define KHomeTabTopAdsViewCell  @"HomeTabTopAdsViewCell"
@interface HomeViewController ()<WBAdsImgViewDelegate,UITableViewDelegate,UITableViewDataSource,RecommendViewCellDelegate>
{
    TKHomeDataModel *model;
    __weak IBOutlet UILabel *labNewUserTime;
    __weak IBOutlet NSLayoutConstraint *tabDisBottom;
    __weak IBOutlet NSLayoutConstraint *tabDisTop;
    __weak IBOutlet UIView *viewNewUser;
    
    WBAdsImgView *adsView;

    __weak IBOutlet UILabel *labNewUserCost;
    CGFloat curY;
    UIView  *menuView;
    __weak IBOutlet UILabel *newUserTitle;
    
    __weak IBOutlet UITableView *tabHomeList;
    __weak IBOutlet UILabel *newUserInfo;
    
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication].keyWindow addSubview:viewNewUser];
        MJWeakSelf;
    self.token = [self.realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        [weakSelf tabReloadData];
    }];

    if ( [[KUserdefaults objectForKey:KloginStatus] boolValue] == NO) {
        [self loadNewUser];
    }

    [self creatSearchUI];
    [self creatRightItem];
    [self setTableView];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    [self requestDataWithoutCache];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tabHomeList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

-(void)loadNewUser{
    
    NSDictionary *pramaDic= [HttpTool getCommonPara];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,APIAddCouption];

    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [tabHomeList.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return ;
        }
        dic = dic[@"data"][@"coupons"];
        if (dic != nil) {  //请求到数据
            viewNewUser.hidden = NO;
            labNewUserCost.text  = [NSString stringWithFormat:@"%.0f",[dic[@"use_money"] doubleValue]];
            newUserInfo.text = [NSString stringWithFormat:@"%@",dic[@"rule_name"]];
            newUserInfo.adjustsFontSizeToFitWidth = YES;
            newUserTitle.text = [NSString stringWithFormat:@" %@   ",dic[@"instructions"]];
            newUserTitle.layer.cornerRadius = newUserTitle.mj_h / 2;
            newUserTitle.layer.masksToBounds = YES;
            NSString *endTime = [dic[@"end_time"] substringFromIndex:5];
            endTime = [endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            NSString *start_time = [dic[@"start_time"] substringFromIndex:5];
            start_time = [start_time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            labNewUserTime.text = [NSString stringWithFormat:@"%@~%@",start_time,endTime];
        }
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
    [itemBtn setBackgroundImage:[UIImage imageNamed:@"首页-消息"] forState:0];
    [rightView addSubview:itemBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)actionSearch{
    DWQSearchController *dwqSearch=[[DWQSearchController alloc]init];
    dwqSearch.seachVCIndex = 0;
    dwqSearch.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:dwqSearch animated:NO];
}
#pragma HomeMenuItemViewDelegate
-(void)itemClick:(SortModel *)index{
    for (int i = 0; i < model.sortList.count ; i++) {
        SortModel *itemmodel =  model.sortList[i];
        if ([itemmodel.sortname isEqualToString:index.sortname]) {
            [self actionGoto:i + 1];
            return;
        }
    }
    [self actionGoto:0];
    
}

#pragma recommendViewCellDelegateMore

-(void)recommendViewCellDelegateMore:(NSInteger)index{
    HonourDetailViewController *honourVC = [[HonourDetailViewController alloc]init];
     MedieaListViewController*medieaVC = [[MedieaListViewController alloc]init];
  
    switch (index) {
            
        case 2:
            [self actionGoto:0];
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


-(void)actionGoto:(NSInteger )index{
    
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
            if (categoryList .count == 0) {
                [self.loadingView showNoticeView:@"暂无更多商品"];
                return;
            }
             category.titleArr = [NSMutableArray arrayWithCapacity:0];
            category.categoryIdArr = [NSMutableArray arrayWithCapacity:0];
            [category.titleArr addObject:@"全部"];
            [category.categoryIdArr addObject:@""];
            for(int i = 0; i < categoryList.count; i++){
                NSDictionary * itemDic = [categoryList objectAtIndex:i];
                [category.titleArr addObject:itemDic[@"name"]];
                [category.categoryIdArr addObject:itemDic[@"styleid"]];
                category.selectedIndex = index;
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
        medieaDetailVC.strUrl =[NSString stringWithFormat:@"%@%@",NewSDetail,model.mediaList[indexpath.row].itemid] ;
        
        medieaDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:medieaDetailVC animated:YES];
        
    }
    
    if (index == 2) {
        GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
        SCCategoryGoodsModel *modelItem = [[SCCategoryGoodsModel alloc]init];
        modelItem.itemid = model.topicList[index].itemid;
        detailVC.goodsM  = modelItem;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    if (index == 4) {
        ImageDetailController *imageDetailVC = [[ImageDetailController alloc]init];
        imageDetailVC.imgUrl = model.honorList[indexpath.row].imgpath;
        [self presentViewController:imageDetailVC animated:NO completion:nil];
    }
}

//-(void)loadData{
//    NSDictionary *dic = [self readLocalFileWithName:@"HomeJson"]; // 模拟网络请求
//    if (dic != nil) {  //请求到数据
//        TKHomeDataModel * homeData = [[TKHomeDataModel alloc]initWith:dic];
//        homeData.modelId = @"1";
//        [self.realm beginWriteTransaction];
//        [self.realm addOrUpdateObject:homeData];
//        [self.realm commitWriteTransaction];
//    }
//    RLMResults *result = [TKHomeDataModel allObjectsInRealm:self.realm];
//    model = [result firstObject];
//    [tabHomeList reloadData];
//}
-(void)actionToMessage{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}
- (IBAction)newUserBackClick:(id)sender {
    viewNewUser.hidden = YES;
}
- (IBAction)lookNewUserGoods:(id)sender {
    viewNewUser.hidden = YES;
    [self goWelcom];
    
}

-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    [self presentViewController:welcomeNav animated:YES completion:nil];
}

@end
