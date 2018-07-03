//
//  CommunityViewController.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityViewCell.h"
#import "CommListModel.h"
#import "PostCommViewController.h"
#import "CommDetailViewController.h"
#import "RootNavigationController.h"
#import "XLImageViewer.h"
#define KCommunityViewCell @"CommunityViewCell"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate,CommunityViewCellDelegate>{
    CommListModelItem *commModel;
    CommListModelItem *shareModel;
    CommListModel *itemModel;
    CommListModel *model;
    NSInteger shareIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIView *shareItemView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *tabCommunityList;
@property (assign,nonatomic)NSInteger page;
@property (strong, nonatomic) IBOutlet UIView *shareView;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    itemModel = [[CommListModel alloc]init];
    [self setTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shareItemView.layer.cornerRadius = 5;
    self.shareItemView.layer.masksToBounds = YES;
    self.btnCancel.layer.cornerRadius = 5;
    self.btnCancel.layer.masksToBounds = YES;
    self.shareView .frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview: self.shareView];
    self.shareView.hidden = YES;
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestHomePageData" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(wxShareBack:) name:WeiXinShare_CallBack object:nil];
    [UITableView refreshHelperWithScrollView:self.tabCommunityList target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
    [self creatRightItem];
    [self loadNewData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    [self.tabCommunityList .mj_header beginRefreshing];
}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"商品分类默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"社区暂无内容哦";
    return str;
}


-(void)creatRightItem{

    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn addTarget:self action:@selector(actionToPostComm) forControlEvents:UIControlEventTouchUpInside];
    itemBtn.frame = CGRectMake(0, 0, 55, 40);
    [itemBtn setImage:[UIImage imageNamed:@"组添加"] forState:0];
    [itemBtn setTitleColor:[UIColor redColor] forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:itemBtn];
}

-(void)setTableView{
    self.tabCommunityList .delegate = self;
    self.tabCommunityList.dataSource = self;
    [self.tabCommunityList registerNib:[UINib nibWithNibName:KCommunityViewCell bundle:nil] forCellReuseIdentifier:KCommunityViewCell];
    self.tabCommunityList.showsVerticalScrollIndicator = NO;
    self.tabCommunityList.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)defaultTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topDis.constant = NaviHeight;
    });
}

-(void)changeTableViewFrame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topDis.constant = NaviHeight + 44;
    });
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
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_GetNoteList];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.tabCommunityList.mj_header endRefreshing];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        NSArray *itemArray = dic[@"data"][@"noteList"];
        [self.tabCommunityList tableViewEndRefreshCurPageCount:itemArray.count];
        if (dic != nil) {
            if (_page == 1) {
                itemModel = [[CommListModel alloc]init];
            }
            for (NSDictionary *itemDic in dic[@"data"][@"noteList"]) {
                [itemModel.commList addObject:[[CommListModelItem alloc]initWith:itemDic]];
            }

        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }
        
//        RLMResults *result = [CommListModel allObjectsInRealm:self.realm];
        model = itemModel;
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

#pragma mark UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return model.commList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [model.commList[indexPath.row] getCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCommunityViewCell];
    [cell refreshData:model.commList[indexPath.row]];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommDetailViewController *detailVC = [[CommDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.commVC = self;
    detailVC.index = indexPath.row;
    detailVC.notiID = model.commList[indexPath.row]._id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)actionToPostComm{
    PostCommViewController *postVC = [[PostCommViewController alloc]init];
    postVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postVC animated:YES];
}

-(void)comunityShare:(CommListModelItem *)model  andIndex:(NSInteger )index{
    shareModel = model;
    shareIndex = index;
    self.shareView.hidden = NO;
}

-(void)communityViewCellGood:(CommListModelItem *)model andIndex:(NSInteger )index{

    
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [pramaDic setObject:model._id forKey:@"noteid"];
    [pramaDic setObject:@"1" forKey:@"type"];
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
                   model.praisenum = [NSString stringWithFormat:@"%ld", [model.praisenum integerValue]+1 ];
        }else{
                   model.praisenum = [NSString stringWithFormat:@"%ld", [model.praisenum integerValue] -1 ];
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

-(void)sumShareNum:(CommListModelItem *)model :(NSInteger )index{
    NSMutableDictionary  *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:model._id forKey:@"noteid"];
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Note_AddforwardNum];
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
        [self.tabCommunityList tableViewEndRefreshCurPageCount:0];
        model.forwardnum = [NSString stringWithFormat:@"%ld", [model.forwardnum integerValue]+1 ];
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tabCommunityList reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)wxShareBack:(NSNotification *)noti{
    if ([noti.object integerValue] == 0) {
        [self.loadingView showNoticeView:@"分享成功"];
        [self sumShareNum:shareModel :shareIndex];
    }else{
        [self.loadingView showNoticeView:@"分享失败"];
    }
}
- (IBAction)shareBack:(id)sender {
    self.shareView.hidden = YES;
}
- (IBAction)shareFirend:(id)sender {
    [self share:WXSceneSession];
}
- (IBAction)shareGroup:(id)sender {
    [self share:WXSceneTimeline];
}

-(void)share:(int)type{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //message是多媒体分享(链接/网页/图片/音乐各种)
        //text是分享文本,两者只能选其一
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = shareModel.title;
        message.description = shareModel.content;
        [message setThumbImage:[UIImage imageNamed:@""]];
        req.message = message;
        WXAppExtendObject *ext = [WXAppExtendObject object];
        ext.url = [NSString stringWithFormat:@"http://tkappmall.tcsw.com.cn/h5/html/community.html?id=%@",shareModel._id];
        message.mediaObject = ext;
        //默认是Session分享给朋友,Timeline是朋友圈,Favorite是收藏
        req.scene = type;
        [WXApi sendReq:req];
        self.shareView.hidden = YES;
    } else {
        [self shownotice];
    }
}

-(void)shownotice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 点击图片放大代理
- (void)showBigImageWithModel:(CommListModelItem *)model andBtn:(UIButton *)sender{
    
    NSMutableArray *imageArr = [NSMutableArray array];
    if (!IsNilOrNull(model.path1)) {
        [imageArr addObject:model.path1];
    }
    if (!IsNilOrNull(model.path2)) {
        [imageArr addObject:model.path2];
    }
    if (!IsNilOrNull(model.path3)) {
        [imageArr addObject:model.path3];
    }
    [[XLImageViewer shareInstanse]showNetImages:imageArr index:sender.tag from:self.view];
}

@end
