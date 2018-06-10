//
//  CollegeViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "CollegeViewController.h"
#import "DWQSearchController.h"
#import "TabTopAdsViewCell.h"

#import "TeacherListVC.h"
#import "ClassListVC.h"
#import "CollegeRootViewCell.h"
#import "TKSchoolModel.h"
#define  KCollegeRootViewCell @"CollegeRootViewCell"
#define KTabTopAdsViewCell @"TabTopAdsViewCell"

@interface CollegeViewController ()<UITableViewDelegate,UITableViewDataSource,CollegeViewCellDelegate>
{
    TKSchoolModel *model;
}
@property (weak, nonatomic) IBOutlet UITableView *tabTKXYRooView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabDisTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabDisBottom;

@end

@implementation CollegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor tt_grayBgColor];
    [self creatSearchUI];
    [self setTableView];
    [UITableView refreshHelperWithScrollView:self.tabTKXYRooView target:self  loadNewData:@selector(loadData) loadMoreData:nil isBeginRefresh:NO];
    [self loadData];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabDisTop.constant = NaviHeight;
        self.tabDisBottom.constant = BOTTOM_BAR_HEIGHT + 49;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabDisTop.constant = NaviHeight + 44;
    });
    
    
}

-(void)requestDataWithoutCache {
    [self loadData];
}

-(void)setTableView{
    self.tabTKXYRooView.delegate = self;
    self.tabTKXYRooView.dataSource = self;
    [self .tabTKXYRooView registerClass:[TabTopAdsViewCell class] forCellReuseIdentifier:KTabTopAdsViewCell];
    [self .tabTKXYRooView registerNib:[UINib nibWithNibName:KCollegeRootViewCell bundle:nil] forCellReuseIdentifier:KCollegeRootViewCell];
    [self.tabTKXYRooView reloadData];
}

-(void)creatSearchUI{
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.frame = CGRectMake(0, 0, KscreenWidth, 30);
    [itemBtn setImage:[UIImage imageNamed:@"搜索"] forState:0];
    [itemBtn setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    itemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [itemBtn setTitle:@"天康学院课堂 " forState:0];
    [itemBtn setBackgroundColor:RGBCOLOR(230 , 230, 230)];
    itemBtn .layer.cornerRadius = 3;
    itemBtn.layer.masksToBounds = YES;
    [itemBtn addTarget:self  action:@selector(actionSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = itemBtn;
}

- (void)actionSearch{
    DWQSearchController *dwqSearch=[[DWQSearchController alloc]init];
    dwqSearch.hidesBottomBarWhenPushed  = YES;
    dwqSearch.seachVCIndex = 1;
    [self.navigationController pushViewController:dwqSearch animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TabTopAdsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTabTopAdsViewCell];
        [cell loadData:model];
        return cell;
    }else{
        CollegeRootViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KCollegeRootViewCell];
        [cell setCollection:indexPath.section withModel:model];
        cell.delegate = self;
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 190 * KscreenWidth / 375.0;;
            break;
        case 1:
            height = 210* KscreenWidth / 375;
            break;
        case 2:
            height = 222* KscreenWidth / 375;
            break;
        case 3:
            height = 258 * KscreenWidth / 375;
            break;
        default:
            height  =0;
            break;
    }
    return height;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark RecommendViewCellDelegate
-(void)CollegeViewCellDelegateMore:(NSInteger)index{
    TeacherListVC *teacherVC = [[TeacherListVC alloc]init];
    ClassListVC *classListVC = [[ClassListVC alloc]init];
    
    switch (index) {
        case 0:
  
            break;
        case 1:
            classListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classListVC animated:YES];
            break;
        case 2:
            teacherVC .hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:teacherVC animated:YES];
            break;
        case 3:
            classListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classListVC animated:YES];
            break;
        case 4:
            
            break;
            
            default:
            break;
    }
}

-(void)loadData{
    
    
    NSDictionary *pramaDic= [HttpTool getCommonPara];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetTkSchoolIndexURl];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.tabTKXYRooView tableViewEndRefreshCurPageCount:0];
        [self.loadingView stopAnimation];
        [self.tabTKXYRooView.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
        if (!IsNilOrNull(meid)) {
    
            NSSet *setTags = [NSSet setWithObject:@"appmall"];
        }
        
        if (dic != nil) {
            model = [[TKSchoolModel alloc]initWith:dic[@"data"]];
            model.modelId = @"1";
            [self.realm beginWriteTransaction];
            [self.realm addOrUpdateObject:model];
            [self.realm commitWriteTransaction];
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
        RLMResults *result = [TKSchoolModel allObjectsInRealm:self.realm];
        model = [result firstObject];
        [self.tabTKXYRooView reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

@end
