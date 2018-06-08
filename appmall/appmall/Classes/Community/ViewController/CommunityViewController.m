//
//  CommunityViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityViewCell.h"
#import "CommListModel.h"
#import "PostCommViewController.h"
#import "CommDetailViewController.h"
#define KCommunityViewCell @"CommunityViewCell"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate,CommunityViewCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *tabCommunityList;
@property (assign,nonatomic)NSInteger page;
@property(nonatomic,strong)CommListModel *model;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    [UITableView refreshHelperWithScrollView:self.tabCommunityList target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    [self creatRightItem];
}
- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@""];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"社区暂无内容哦";
    return str;
}


-(void)creatRightItem{

    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn addTarget:self action:@selector(actionToPostComm) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.frame = CGRectMake(0, 0, 33, 33);
    [itemBtn setImage:[UIImage imageNamed:@"组添加"] forState:0];
    [itemBtn setTitleColor:[UIColor redColor] forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
}

-(void)setTableView{
    self.tabCommunityList .delegate = self;
    self.tabCommunityList.dataSource = self;
    [self.tabCommunityList registerNib:[UINib nibWithNibName:KCommunityViewCell bundle:nil] forCellReuseIdentifier:KCommunityViewCell];
    self.tabCommunityList.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topDis.constant = NaviHeight;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topDis.constant = NaviHeight + 44;
    });
}

-(void)requestDataWithoutCache {
    [self loadNewData];
}

-(void)loadNewData{
    _page =  1;
    [self loadData];
}

-(void)loadMoreData{
    _page ++;
    [self loadData];
}

-(void)loadData{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_GetNoteList];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.tabCommunityList.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        NSArray *itemArray = dic[@"data"][@"noteList"];
        [self.tabCommunityList tableViewEndRefreshCurPageCount:itemArray.count];
        if (dic != nil) {
            CommListModel *itemModel = [[CommListModel alloc]init];
            for (NSDictionary *itemDic in dic[@"data"][@"noteList"]) {
                [itemModel.commList addObject:[[CommListModelItem alloc]initWith:itemDic]];
            }
            itemModel.commId = @"1";
            [self.realm beginWriteTransaction];
            [self.realm addOrUpdateObject:itemModel];
            [self.realm commitWriteTransaction];
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
        
        RLMResults *result = [CommListModel allObjectsInRealm:self.realm];
        self.model = [result firstObject];
        [self.tabCommunityList reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.commList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.model.commList[indexPath.row] getCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommunityViewCell];
    [cell refreshData:self.model.commList[indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommDetailViewController *detailVC = [[CommDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.notiID = self.model.commList[indexPath.row]._id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)actionToPostComm{
    PostCommViewController *postVC = [[PostCommViewController alloc]init];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
}



-(void)communityViewCellGood:(CommListModelItem *)model{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:model._id forKey:@"noteid"];
    [pramaDic setObject:@"1" forKey:@"type"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_EditPraise];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        
        [self loadNewData];
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
