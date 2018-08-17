//
//  TeacherListVC.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeacherListVC.h"
#import "TeacherDetailVC.h"
#import "TeacherItemViewCell.h"
#import "TeacherListItemModel.h"
#define KTeacherItemViewCell @"TeacherItemViewCell"

@interface TeacherListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet NSLayoutConstraint *tabDisBottom;
    __weak IBOutlet NSLayoutConstraint *tabDisTop;
}
@property(assign,nonatomic)NSInteger page;
@property (weak, nonatomic) IBOutlet UITableView *tabTeaCherListView;
@property(nonatomic,strong)NSMutableArray <TeacherListItemModel *>*teacherArray;
@end

@implementation TeacherListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名师指路";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _teacherArray = [NSMutableArray arrayWithCapacity:0];
    [UITableView refreshHelperWithScrollView:self.tabTeaCherListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self setTableView];
    tabDisTop.constant = NaviHeight;
    [self loadNewData];
}

-(void)loadNewData{
    _page = 1;
    [self loadData];
}
-(void)loadMoreData{
    _page ++;
    [self loadData];
}

-(void)loadData{
    
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setValuesForKeysWithDictionary:@{@"pageNo":@(_page),@"pageSize":@(KpageSize)}];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetTeacherList];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            [self.tabTeaCherListView tableViewEndRefreshCurPageCount:0];
            return;
        }
        if (self.page == 1) {
            [_teacherArray removeAllObjects];
        }
        NSArray *teacherList = dic[@"data"][@"teacherList"];
        [self.tabTeaCherListView tableViewEndRefreshCurPageCount:teacherList.count];
        if (dic != nil) {
            for (NSDictionary *itemDic in dic[@"data"][@"teacherList"]) {
                [_teacherArray addObject:[[TeacherListItemModel alloc]initWith:itemDic]];
            }
            [self.tabTeaCherListView reloadData];
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
        
    } failure:^(NSError *error) {
        [self.tabTeaCherListView tableViewEndRefreshCurPageCount:0];
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)setTableView{
    self.tabTeaCherListView.delegate = self;
    self.tabTeaCherListView.dataSource= self;
    [self.tabTeaCherListView registerNib:[UINib nibWithNibName:KTeacherItemViewCell bundle:nil ] forCellReuseIdentifier:KTeacherItemViewCell];
    self.tabTeaCherListView.rowHeight = 136;
    [self .tabTeaCherListView reloadData];
    self.tabTeaCherListView.tableFooterView = [UIView new];
    tabDisTop.constant = NaviHeight;
    tabDisBottom .constant = BOTTOM_BAR_HEIGHT ;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teacherArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeacherItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTeacherItemViewCell];
    [cell refreshDataWithModel:[self.teacherArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TeacherDetailVC *detailVC = [[TeacherDetailVC alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.teacherId = [self.teacherArray objectAtIndex:indexPath.row].teacherId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
