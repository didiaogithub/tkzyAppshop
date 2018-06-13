

//
//  MessageViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageDetailViewCell.h"
#import "MessageOffDetailViewCell.h"
#import "MessagModel.h"
#import "WebDetailViewController.h"

#define KMessageDetailViewCell @"MessageDetailViewCell"
#define KMessageOffDetailViewCell @"MessageOffDetailViewCell"
@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *messageListIView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic, strong) NodataLableView *nodataLableView;
@property(nonatomic,strong)NSMutableArray <MessagDetailModel *> *messageList;
@end
@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.titleStr;
    [UITableView refreshHelperWithScrollView:self.messageListIView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
 

    self.topDis.constant = NaviHeight;
    self.messageList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    
    // Do any additional setup after loading the view from its nib.
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setTableView];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.messageListIView.delegate = self;
    self.messageListIView.dataSource = self;
    [self.messageListIView registerNib:[UINib nibWithNibName:KMessageDetailViewCell bundle:nil] forCellReuseIdentifier:KMessageDetailViewCell];
       [self.messageListIView registerNib:[UINib nibWithNibName:KMessageOffDetailViewCell bundle:nil] forCellReuseIdentifier:KMessageOffDetailViewCell];
    [self .messageListIView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.messageType integerValue] == 0) {
        MessageOffDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageOffDetailViewCell];
        [cell loadData:(MessagDetailOffModel *)self.messageList[indexPath.row]];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        return  cell;
    }else{
        MessageDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageDetailViewCell];
        [cell loadData:self.messageList[indexPath.row]];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        return  cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.messageType integerValue] == 0) {
        MessagDetailOffModel *model =(MessagDetailOffModel *)self.messageList[indexPath.row];
      return  [model getCellHeight];
    }else{
        return 140;
    }
    
}

-(void)requestData {
    
    _nodataLableView.hidden = YES;
    
    
    NSMutableDictionary  *pramaDic= [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    NSString *api =APIgetMessageList;
    if ([self.messageType integerValue] == 0) {
        api =APIgetOfficialMessageList;
    }else{
        [pramaDic setObject:self.messageType forKey:@"messageType"];
    }
    
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, api];
    
    NSLog(@"请求参数：%@", pramaDic);
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        
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
            
            [self.messageListIView tableViewEndRefreshCurPageCount:0];
         
        }else{
            NSArray *itemList =dic[@"data"][@"messages"];
            [self.messageListIView tableViewEndRefreshCurPageCount:itemList .count];
            for (NSDictionary *itemDic in itemList) {
                if ([self.messageType integerValue] == 0) {
                    MessagDetailOffModel *model = [[MessagDetailOffModel alloc]initWith:itemDic];
                    [self.messageList addObject:model];
                }else{
                    MessagDetailModel *model = [[MessagDetailModel alloc]initWith:itemDic];
                    [self.messageList addObject:model];
                }
              
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
    if ([self.messageType integerValue] == 0) {
   MessagDetailOffModel *model =  self.messageList[indexPath.row];
        WebDetailViewController *webDetail = [[WebDetailViewController alloc]init];
        webDetail.detailUrl = [NSString stringWithFormat:@"%@h5/html/officialnotice.html?id=%@",WebServiceAPI,model.msgId];
        [self.navigationController pushViewController:webDetail animated:YES];
    }
}
@end
