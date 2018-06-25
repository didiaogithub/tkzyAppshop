

//
//  MessageViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListViewCell.h"
#import "MessageDetailViewController.h"
#import "MessagModel.h"

#define KMessageListViewCell @"MessageListViewCell"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *messageListIView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property(nonatomic,strong)NSMutableArray <MessagModel *> *messageList;
@property(nonatomic,assign)NSInteger page;
@end
@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int gfcount = [CKJPushManager manager].gfMessageCount;
    int wlcount = [CKJPushManager manager].wlMessageConut;
    int ddcount = [CKJPushManager manager].ddMessageCount;
    int fpcount = [CKJPushManager manager].fpMessageCount;
    int fqcount = [CKJPushManager manager].fqMessageCount;
    int totalcount = gfcount + wlcount + ddcount + fqcount + fpcount;
    if (totalcount == 0) {
        [CKCNotificationCenter postNotificationName:@"hiddenWhiteLab" object:nil];
    }
    
    [self setTableView];
    
     [UITableView refreshHelperWithScrollView:self.messageListIView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
}


- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"商品分类默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无此类提醒哦";
    return str;
}


-(void)loadNewData{
    _page =  1;
    [self requestData];
}

-(void)loadMoreData{
    _page ++;
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"消息中心";
    self.topDis.constant = NaviHeight;
    self.messageList = [NSMutableArray arrayWithCapacity:0];
    [self requestData];
    [CKCNotificationCenter addObserver:self selector:@selector(refreshMessageCount) name:@"refreshMessageCount" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshMessageCount{
    [self.messageListIView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setTableView];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.messageListIView.delegate = self;
    self.messageListIView.dataSource = self;
    [self.messageListIView registerNib:[UINib nibWithNibName:KMessageListViewCell bundle:nil] forCellReuseIdentifier:KMessageListViewCell];
    [self .messageListIView reloadData];
    self.messageListIView.backgroundColor = [UIColor tt_grayBgColor];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    [cell loadData:self.messageList[indexPath.row]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

-(void)requestData {
    
    _nodataLableView.hidden = YES;
    
    
    NSDictionary *pramaDic= [HttpTool getCommonPara];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, APIGetMessageSortList];
    
    NSLog(@"请求参数：%@", pramaDic);
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        [self.messageListIView.mj_header endRefreshing];
        [self.messageListIView.mj_footer endRefreshing];
        
        if ([dic[@"code"] integerValue] !=  200) {
            [self showNoticeView:dic[@"message"]];
            return ;
        }
        
        if (_page == 1) {
            [self.messageList removeAllObjects];
        }
        NSLog(@"%@", dic);
        if (dic == nil) {
            
            _nodataLableView.hidden = NO;
            
            [self.messageListIView reloadData];
            
            [self.messageListIView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
            [self.messageListIView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            for (NSDictionary *itemDic in dic[@"data"][@"messages"]) {
                MessagModel *model = [[MessagModel alloc]initWith:itemDic];
                [self.messageList addObject:model];
            }
            [self.messageListIView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        
        [self.messageListIView.mj_header endRefreshing];
        [self.messageListIView.mj_footer endRefreshing];
        if (self.dataArr.count == 0) {
            _nodataLableView.hidden = NO;
            [self.messageListIView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
        
        if(self.dataArr.count == 0){
            _nodataLableView.hidden = NO;
            [self.messageListIView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
        }
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc]init];
   
    detailVC.messageType = self.messageList[indexPath.row].messageType;
    
    if ([detailVC.messageType isEqualToString:@"1"]) {
        [CKJPushManager manager].wlMessageConut = 0;
    }else if ([detailVC.messageType isEqualToString:@"2"]){
        [CKJPushManager manager].ddMessageCount = 0;
    }else if ([detailVC.messageType isEqualToString:@"3"]){
        [CKJPushManager manager].fqMessageCount = 0;
    }else if ([detailVC.messageType isEqualToString:@"4"]){
        [CKJPushManager manager].fpMessageCount = 0;
    }else{
        [CKJPushManager manager].gfMessageCount = 0;
    }
    detailVC.titleStr = self.messageList[indexPath.row].name;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}
@end
