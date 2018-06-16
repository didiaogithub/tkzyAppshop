

//
//  CommPLDetailViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommPLDetailViewController.h"
#import "CommPingLunModel.h"
#import "CommPingLunViewCell.h"
#define KCommPingLunViewCell @"CommPingLunViewCell"
@interface CommPLDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CommPingLunViewCellDelegate,UITextFieldDelegate,CommPingLunViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabCommunityList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property(nonatomic,assign)NSInteger page;
@property(strong,nonatomic)CommPingLunModel *commListModel;
@property(nonatomic,strong)UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *sadf;
@property(nonatomic,strong)NSString *commId;
@property(nonatomic,strong)UITextField *commInput;
@end

@implementation CommPLDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    self.topDis.constant =NaviHeight;
    [self creataToolBar];
    [self setTableView];
    [UITableView refreshHelperWithScrollView:self.tabCommunityList target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self loadNewData];
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
    
    [pramaDic setObject:self.communityid forKey:@"communityid"];
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_GetCommunity];
    
    
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
            NSDictionary *commArray = dic[@"data"];
            [self.tabCommunityList tableViewEndRefreshCurPageCount:commArray.count];
            self.commListModel = [[CommPingLunModel alloc]initWith:commArray];
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

-(void)submitComm:(NSString *)comm commId:(NSString *)commid{
    [self.view endEditing:YES];
    if (comm .length == 0) {
        [self.loadingView showNoticeView:@"评论不能为空"];
        
    }
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notied forKey:@"noteid"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commListModel.comments.count + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath .row == 0) {
        return [self.commListModel getCellHeightNoComment];
    }else{
        return [self.commListModel.comments[indexPath.row-1] getCellHeight];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommPingLunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommPingLunViewCell];
    if (indexPath .row == 0) {
        [cell refreshData:self.commListModel IsneedCommView:NO];
        cell.delegate = self;
    }else{
        [cell refreshDataDetail:self.commListModel.comments[indexPath.row-1]];
        cell.delegate = nil;
    }
    cell.index = indexPath.row;
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)communityViewCellGood:(CommPingLunModel *)model andIndex:(NSInteger )index{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notied forKey:@"noteid"];
    [pramaDic setObject:@"2" forKey:@"type"];
    [pramaDic setObject:model._id forKey:@"commentid"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_EditPraise];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            
            
            return;
        }
        model.ispraise = [NSString stringWithFormat:@"%d", ![model.ispraise boolValue]];
        if ([model.ispraise boolValue]) {
            model.praise = [NSString stringWithFormat:@"%ld", [model.praise integerValue]+1 ];
        }else{
            model.praise = [NSString stringWithFormat:@"%ld", [model.praise integerValue] -1 ];
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tabCommunityList reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        if ([model.ispraise boolValue]) {
            [self.loadingView showNoticeView:@"点赞成功"];
        }else{
            [self.loadingView showNoticeView:@"取消点赞"];
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

-(void)actionComment:(CommPingLunModel *)model{
    self.commInput.returnKeyType = UIReturnKeySend;
    [self.sadf becomeFirstResponder];
    [self.commInput becomeFirstResponder];
    [self.sadf resignFirstResponder];
    self.commInput.delegate = self;
    self.commId =model._id;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.sadf resignFirstResponder];
    [self.commInput resignFirstResponder];
    [self  submitComm:textField.text commId:self.commId];
    
    return YES;
}

@end
