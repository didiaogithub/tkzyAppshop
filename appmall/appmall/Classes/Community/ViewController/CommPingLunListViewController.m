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
#define KCommPingLunViewCell @"CommPingLunViewCell"
@interface CommPingLunListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CommPingLunViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabCommunityList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property(nonatomic,assign)NSInteger page;
@property(strong,nonatomic)NSMutableArray <CommPingLunModel *>*commList;
@property(nonatomic,strong)UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *sadf;

@property(nonatomic,strong)UITextField *commInput;
@property(nonatomic,strong)NSString * commId;
@end

@implementation CommPingLunListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"全部评论";
    self.commList = [NSMutableArray arrayWithCapacity:0];
    self.topDis.constant =NaviHeight;
    [self setTableView];
    [UITableView refreshHelperWithScrollView:self.tabCommunityList target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    [self creataToolBar];
}
-(void)setTableView{
    self.tabCommunityList .delegate = self;
    self.tabCommunityList.dataSource = self;

    [self.tabCommunityList registerNib:[UINib nibWithNibName:KCommPingLunViewCell bundle:nil] forCellReuseIdentifier:KCommPingLunViewCell];
    
}

-(void)creataToolBar{
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 50)];
    self.commInput = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, KscreenWidth -10, 40)];
    [self.view addSubview:self.commInput];
    UIBarButtonItem *itemsubmit = [[UIBarButtonItem alloc]initWithCustomView:self.commInput];
    NSArray * buttonsArray = [NSArray arrayWithObjects:itemsubmit,nil];
    self.toolBar.opaque = YES;
    self.commInput.placeholder = @"添加一条评论";
    self.commInput .layer.borderColor = RGBCOLOR(200, 200, 200).CGColor;
    self.commInput.layer.borderWidth = 1;
    self.commInput.layer.cornerRadius = 4;
    self.commInput.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.commInput.leftViewMode = UITextFieldViewModeAlways;
    self.commInput.layer.masksToBounds = YES;
    [self.toolBar setItems:buttonsArray];
    [self.sadf setInputAccessoryView:self.toolBar];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
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
        if (_page == 1) {
             [self.commList removeAllObjects];
        }
        
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
    [cell refreshData:self.commList[indexPath.row] IsneedCommView:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.notId = self.notiID;
    
    cell.delegate = self;
    return cell;
}


-(void)communityViewCellGood:(CommPingLunModel *)model{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notiID forKey:@"noteid"];
    [pramaDic setObject:@"2" forKey:@"type"];
    [pramaDic setObject:model._id forKey:@"commentid"];
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

- (IBAction)actionSubmitComm:(id)sender {
    self.commInput.returnKeyType = UIReturnKeySend;
    [self.sadf becomeFirstResponder];
    [self.commInput becomeFirstResponder];
    [self.sadf resignFirstResponder];
    self.commInput.delegate = self;
    self.commId = nil;
//    [self.commInput becomeFirstResponder];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.sadf resignFirstResponder];
    [self.commInput resignFirstResponder];
    [self  submitComm:textField.text commId:self.commId];

    return YES;
}

-(void)submitComm:(NSString *)comm commId:(NSString *)commid{
    if (comm .length == 0) {
        [self.loadingView showNoticeView:@"评论不能为空"];
        
    }
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notiID forKey:@"noteid"];
    if (commid == nil) {
        [pramaDic setObject:@"1" forKey:@"type"];
    }else{
        [pramaDic setObject:@"2" forKey:@"type"];
        [pramaDic setObject:commid forKey:@"commentid"];
    }
    
    [pramaDic setObject:comm forKey:@"content"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_AddCommunity];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        [self.loadingView showNoticeView:dic[@"message"]];
        self.commInput.text = @"";
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

-(void)actionComment:(CommPingLunModel *)model{
    self.commInput.returnKeyType = UIReturnKeySend;
    [self.sadf becomeFirstResponder];
    [self.commInput becomeFirstResponder];
    [self.sadf resignFirstResponder];
    self.commInput.delegate = self;
    self.commId =model._id;
}



@end