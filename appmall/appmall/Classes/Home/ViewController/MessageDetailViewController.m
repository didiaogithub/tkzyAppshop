

//
//  MessageViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageListViewCell.h"
#import "MessagModel.h"

#define KMessageListViewCell @"MessageListViewCell"

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *messageListIView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property(nonatomic,strong)NSMutableArray <MessagModel *> *messageList;
@end
@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITableView refreshHelperWithScrollView:self.messageListIView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
 

    self.topDis.constant = NaviHeight;
    self.messageList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadNewData{
    _page =  1;
    [self requestData];
}

-(void)loadMoreData{
    _page ++;
    [self requestData];
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageListViewCell];

    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)requestData {
    
    _nodataLableView.hidden = YES;
    
    
    NSMutableDictionary  *pramaDic= [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:@"" forKey:@"messageType"];
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, APIgetMessageList];
    
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
    
}
@end
