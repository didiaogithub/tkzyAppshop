//
//  ClassListCellViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassListCellViewController.h"
#import "WBMenu.h"
#import "ClassItemViewCell.h"
#import "WebDetailViewController.h"
#import "ClassListModel.h"
#define KClassItemViewCell @"ClassItemViewCell"
@interface ClassListCellViewController ()<WBMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property(nonatomic,strong)NSMutableArray <ClassListModel *>*classArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation ClassListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT + 84;
    [UITableView refreshHelperWithScrollView:self.classListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    self.classArray = [NSMutableArray arrayWithCapacity:0];
}


-(void)loadNewData{
    _page = 1;
    [self loadData];
}
-(void)loadMoreData{
    _page ++;
    [self loadData];
}
- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"无课程"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无此类课程哦";
    return str;
}

-(void)setTableView{
    self.classListView .delegate = self;
    self.classListView.rowHeight = 140;
    self.classListView.dataSource = self;
    
    [self.classListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{

    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setValuesForKeysWithDictionary:@{@"pageNo":@(_page),@"pageSize":@(KpageSize),@"categoryId":_classItem.categoryId}];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetCourseList];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.classListView tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        if (_page == 1) {
            [self.classArray removeAllObjects];
        }
        NSArray *list = dic[@"data"][@"courseList"];
        [self.classListView tableViewEndRefreshCurPageCount:list.count];
        if (dic != nil) {
            for (NSDictionary *itemDic in dic[@"data"][@"courseList"]) {
                ClassListModel *model = [[ClassListModel alloc]initWith:itemDic];
                [self.classArray addObject:model];
            }
            [self .classListView reloadData];
        }else{
            [self.loadingView showNoticeView:@"无更多课程"];
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

-(void)refresh{
//    [self showNoticeView:@"刷新数据"];
}

-(BOOL)isRefresh{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KClassItemViewCell];
    [cell refreshDataWIthModel:[self.classArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
    webDetailVC.detailUrl = [NSString stringWithFormat:@"%@h5/html/course.html?id=%@",WebServiceAPI,self.classArray[indexPath.row].courseId];
    [self.navVC.navigationController pushViewController:webDetailVC animated:YES];
}

@end
