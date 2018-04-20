//
//  HomeViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "HomeViewController.h"
#import "DWQSearchController.h"
#import "WBAdsImgView.h"
#import "HomeMenuItemView.h"
#import "RecommendViewCell.h"
#import "HonourDetailViewController.h"
#import "MessageViewController.h"
#import "SCCategoryViewController.h"
#import "MedieaListViewController.h"
#define KRecommendViewCell @"RecommendViewCell"
@interface HomeViewController ()<WBAdsImgViewDelegate,HomeMenuItemViewDelegate,UITableViewDelegate,UITableViewDataSource,RecommendViewCellDelegate>
{
    
    __weak IBOutlet UIScrollView *scroMainView;
    __weak IBOutlet UIView *contentSrcView;
    WBAdsImgView *adsView;
    __weak IBOutlet NSLayoutConstraint *heightContentView;
    CGFloat curY;
    UIView  *menuView;
    __weak IBOutlet NSLayoutConstraint *disTop;
    __weak IBOutlet UITableView *tabHomeList;
    __weak IBOutlet NSLayoutConstraint *tabDisTop;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatSearchUI];
    [self creatRightItem];
    [self setADSUI];
    [self setMenu];
    [self setTableView];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        disTop.constant = NaviHeight;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        disTop.constant = NaviHeight + 44;
    });
    

}

-(void)requestDataWithoutCache {
//    [self loadHomeData:YES];
}

-(void)loadHomeData:(BOOL)showLoading {
    
    NSDictionary *pramaDic= @{@"openid":USER_OPENID};
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
            [self.loadingView showNoticeView:dic[@"msg"]];
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
        
//        [self analysisDatas:dic];
//        [self bindFirstPageData];
        //创建分享按钮2017.10.12
//        [self createShareButton];
        //连接融云或者智齿
//        [self connectRCloudOrTooth];
        
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
    [tabHomeList reloadData];
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
    [cell setCollection:indexPath.row];
    cell.delegate = self;
    heightContentView.constant = tableView.contentSize.height + tableView.mj_y;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        RecommendViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KRecommendViewCell];
    return [cell getCollectionHeight:indexPath.row];
    
}

-(void)adsImgViewClick:(ADSModel*)itemIndex{
    
}

-(void)setADSUI{
    if (adsView == nil) {
        adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, KscreenWidth/2)];
        adsView.delegate = self;
        [contentSrcView addSubview:adsView];
    }
    [adsView setImageUrlArray:nil];
}

-(void)setMenu{
    curY = adsView.mj_y + adsView.mj_h ;
    if (menuView != nil) {
        return;
    }
    menuView = [[UIView alloc]initWithFrame:CGRectMake(0, curY, KscreenWidth, 93)];
    [contentSrcView addSubview:menuView];
    
    NSArray *items = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"HomeMenuItemsConfig" ofType: @"plist"]];
    NSInteger width = KscreenWidth/items.count;
    NSInteger height = menuView.mj_h;
    for (int i = 0; i<items.count; i++) {
        NSDictionary *itemdic = items[i];
        HomeMenuItemView *menuItem = [[HomeMenuItemView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        [menuItem setItemIcom:[UIImage imageNamed:itemdic[@"itemImage"]] title:itemdic[@"itemTitle"] setTag:1000+i];
        
        
        menuItem.delegate = self;
        menuView.backgroundColor = [UIColor whiteColor];
        [menuView addSubview:menuItem];
    }
    curY = menuView.mj_h + menuView.mj_y + 10;
    tabDisTop.constant = curY;
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
    SCCategoryViewController *category = [[SCCategoryViewController alloc] init];
    switch (index) {
            
        case 0:
            
            category.titleArr = [NSMutableArray arrayWithArray: @[@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈"]];
            category.categoryIdArr =[NSMutableArray arrayWithArray: @[@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈",@"哈哈"]];
            category.selectedIndex = 0;
            [self.navigationController pushViewController:category animated:YES];
            break;
        case 1:
            medieaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:medieaVC animated:YES];
            
            break;
        case 2:
            honourVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:honourVC animated:YES];
            break;
            
        default:
            break;
    }
}

-(void)actionToMessage{
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}
@end
