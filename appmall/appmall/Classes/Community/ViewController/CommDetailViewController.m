
//
//  CommDetailViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CommDetailViewController.h"
#import "CommPingLunListViewController.h"
#import "CommPingLunViewCell.h"
#import "CommHeaderViewCell.h"
#import "CommDetail.h"
#import "CommListModel.h"
#define KCommHeaderViewCell @"CommHeaderViewCell"
#define KCommPingLunViewCell @"CommPingLunViewCell"

@interface CommDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CommPingLunViewCellDelegate,UITextFieldDelegate>{
    CommPingLunListViewController *listVC;
    CommDetail *commDetail;
    
}
@property(nonatomic,strong)NSString * commId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property(nonatomic,strong)UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *sadf;

@property(nonatomic,strong)UITextField *commInput;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tabCommDetail;
@property (weak, nonatomic) IBOutlet UITableView *item;


@end

@implementation CommDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDis.constant = NaviHeight;
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableView];
    [self loadData];
    [self creataToolBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setTableView{
    self.tabCommDetail .delegate = self;
    self.tabCommDetail.dataSource = self;
    [self.tabCommDetail registerNib:[UINib nibWithNibName:KCommPingLunViewCell bundle:nil] forCellReuseIdentifier:KCommPingLunViewCell];
    [self.tabCommDetail registerNib:[UINib nibWithNibName:KCommHeaderViewCell bundle:nil] forCellReuseIdentifier:KCommHeaderViewCell];
}


-(void)loadData{
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notiID forKey:@"noteid"];
    
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_getNoteById];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.tabCommDetail.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommDetail tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        
      
        [self.tabCommDetail tableViewEndRefreshCurPageCount:0];
        if (dic != nil) {
            commDetail = [[CommDetail alloc]initWith:dic[@"data"]];
        }else{
            [self.loadingView showNoticeView:@"暂无数据"];
        }
        
        [self.tabCommDetail reloadData];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (commDetail.comments .count == 0) {
        return 1;
    }else{
        return 2;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return commDetail.comments.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CommHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommHeaderViewCell];
        [cell loadDataWithModel:commDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CommPingLunViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommPingLunViewCell];
        [cell refreshData:commDetail.comments[indexPath.row] IsneedCommView:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.notId = commDetail._id;
        cell.index = indexPath.row;
        cell.delegate   = self;
        return cell;
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return _headerView;
    }else{
        return [UIView new];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
        return [UIView new];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [commDetail getCellHeight];
    }else{
        return [commDetail .comments[indexPath.row] getCellHeightCommdetail];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return  45;
    }else{
        return 0.1;
    }
}

- (IBAction)acitonMoreCom:(id)sender {
    CommPingLunListViewController *listVC = [[CommPingLunListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.notiID =commDetail._id;
    [self.navigationController pushViewController:listVC animated:YES];
}

-(void)communityViewCellGood:(CommListModelItem *)model andIndex:(NSInteger )index{
    
    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:self.notiID forKey:@"noteid"];
    [pramaDic setObject:model._id forKey:@"commentid"];
    [pramaDic setObject:@"2" forKey:@"type"];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_EditPraise];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool postWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommDetail tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            
            
            return;
        }
        model.ispraise = [NSString stringWithFormat:@"%d", ![model.ispraise boolValue]];
        if ([model.ispraise boolValue]) {
            model.praisenum = [NSString stringWithFormat:@"%ld", [model.praisenum integerValue]+1 ];
            [model setValue:[NSString stringWithFormat:@"%ld", [model.praisenum integerValue]+1 ] forKey:@"praise"];
        }else{
             model.praisenum = [NSString stringWithFormat:@"%ld", [model.praisenum integerValue] -1 ];
             [model setValue:[NSString stringWithFormat:@"%ld", [model.praisenum integerValue]-1 ] forKey:@"praise"];
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:1];
        [self.tabCommDetail reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        if ([model.ispraise boolValue]) {
            [self.loadingView showNoticeView:@"点赞成功"];
        }else{
            [self.loadingView showNoticeView:@"取消点赞"];
        }
//        [self loadData];
        
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
        [self loadData];
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
