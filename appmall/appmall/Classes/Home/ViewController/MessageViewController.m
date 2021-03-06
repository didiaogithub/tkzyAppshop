

//
//  MessageViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListViewCell.h"

#define KMessageListViewCell @"MessageListViewCell"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *messageListIView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NodataLableView *nodataLableView;

@end
@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMessageListViewCell];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
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
        
        NSLog(@"%@", dic);
        if (dic == nil) {
            
            _nodataLableView.hidden = NO;
            [self.dataArr removeAllObjects];
            
            [self.messageListIView reloadData];
            
            [self.messageListIView tableViewDisplayView:self.nodataLableView ifNecessaryForRowCount:self.dataArr.count];
            [self.messageListIView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            self.dataArr = [NSMutableArray array];
         
            
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

@end
