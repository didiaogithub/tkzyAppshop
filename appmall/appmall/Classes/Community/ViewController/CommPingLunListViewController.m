//
//  CommPingLunListViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommPingLunListViewController.h"
#import "CommPingLunViewCell.h"
#import "CommPingLunModel.h"
#define KCommPingLunViewCell @"CommPingLunViewCell.h"
@interface CommPingLunListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabCommunityList;
@property(nonatomic,assign)NSInteger page;
@property(strong,nonatomic)NSMutableArray <CommPingLunModel *>*commList;
@end

@implementation CommPingLunListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    [UITableView refreshHelperWithScrollView:self.tabCommunityList target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
}
-(void)setTableView{
    self.tabCommunityList .delegate = self;
    self.tabCommunityList.dataSource = self;
    [self.tabCommunityList registerNib:[UINib nibWithNibName:KCommPingLunViewCell bundle:nil] forCellReuseIdentifier:KCommPingLunViewCell];
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

    [pramaDic setObject:self.notiID forKey:@"noteid"];
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_GetCommunityShowList];
    
    
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

        [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
        if (dic != nil) {
            NSArray *commArray = dic[@"data"][@"communitys"];
            [self.tabCommunityList tableViewEndRefreshCurPageCount:commArray.count];
            for (NSDictionary *itemDic in commArray) {
                CommPingLunModel *model = [[CommPingLunModel alloc]initWith:itemDic];
                [self.commList addObject:model];
            }
            [self .tabCommunityList reloadData];
        }else{
            [self.loadingView showNoticeView:@"无更多评论"];
        }
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.commList[indexPath.row] getCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommPingLunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommPingLunViewCell];
    [cell refreshData:self.commList[indexPath.row]];
    return cell;
}


@end
