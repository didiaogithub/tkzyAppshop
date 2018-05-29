//
//  GoodsDetailViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsDetailHeader.h"
#import "GoodSDetailBackViewCell.h"
#import "GoodSdetailBottomViewCell.h"
#import "GoodSdetailHeaderViewCell.h"
#import "GoodDetailModel.h"
#import "SCConfirmOrderVC.h"

#define  KGoodsDetailHeader @"GoodsDetailHeader"
#define  KGoodSDetailBackViewCell @"GoodSDetailBackViewCell"
#define  KGoodSdetailBottomViewCell @"GoodSdetailBottomViewCell"
#define  KGoodSdetailHeaderViewCell @"GoodSdetailHeaderViewCell"

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *goodsView;
    UIButton *commView;
    UIButton *detailView;
    BOOL isDrag;
}
@property (weak, nonatomic) IBOutlet UITableView *tabGoodDetail;
@property (nonatomic,strong)GoodDetailModel *detailModel;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setTableView];
    [self createTitleView];
    
    [self refreshUI];
}

-(void)createTitleView{
    UIView*titleView = [[UIView alloc]initWithFrame:CGRectMake(90, 0, KscreenWidth - 180, 35)];
    goodsView = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsView setTitle:@"商品" forState:0];
    goodsView.tag = 1000;
    goodsView.frame = CGRectMake(0, 0, titleView.mj_w / 3, titleView.mj_h);
    [goodsView setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [goodsView setTitleColor:RGBCOLOR(241, 29, 27) forState:UIControlStateSelected];
    [titleView addSubview:goodsView];
    [goodsView addTarget:self action:@selector(goodInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    goodsView.selected = YES;
    
    commView = [UIButton buttonWithType:UIButtonTypeCustom];
    commView.tag = 1001;
    commView.frame = CGRectMake(titleView.mj_w / 3, 0, titleView.mj_w / 3, titleView.mj_h);
    [commView setTitle:@"评价" forState:0];
    [commView setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [commView setTitleColor:RGBCOLOR(241, 29, 27) forState:UIControlStateSelected];
    [commView addTarget:self action:@selector(commInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:commView];
    
    detailView = [UIButton buttonWithType:UIButtonTypeCustom];
    detailView.tag = 1002;
    detailView.frame = CGRectMake(titleView.mj_w / 3 * 2, 0, titleView.mj_w / 3, titleView.mj_h);
    [detailView setTitle:@"详情" forState:0];
    [detailView setTitleColor:RGBCOLOR(72, 72, 72) forState:0];
    [detailView setTitleColor:RGBCOLOR(241, 29, 27) forState:UIControlStateSelected];
    [detailView addTarget:self action:@selector(bottomInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:detailView];
    
    self.navigationItem.titleView = titleView;
}

-(void)scroTableView:(UIButton *)sender{
    isDrag = NO;
    [self setTitleViewState:sender];
    NSIndexPath *indexp ;
    if (self.detailModel.commentList.count == 0 && sender.tag == 1001) {
        indexp = [NSIndexPath indexPathForRow:0 inSection:2];
    }else{
            indexp = [NSIndexPath indexPathForRow:0 inSection:sender.tag  - 1000];
    }

    [self.tabGoodDetail scrollToRowAtIndexPath:indexp atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)goodInfoClick:(UIButton *)sender{
    [self scroTableView:sender];
}

-(void)commInfoClick:(UIButton *)sender{
    [self scroTableView:sender];
}

-(void)bottomInfoClick:(UIButton *)sender{
        [self scroTableView:sender];
}

-(void)setTableView{
    self.tabGoodDetail.delegate = self;
    self.tabGoodDetail.dataSource = self;
    [self.tabGoodDetail registerNib:[UINib nibWithNibName:KGoodSDetailBackViewCell  bundle:nil] forCellReuseIdentifier:KGoodSDetailBackViewCell];
    [self.tabGoodDetail registerNib:[UINib nibWithNibName:KGoodSdetailBottomViewCell bundle:nil] forCellReuseIdentifier:KGoodSdetailBottomViewCell];
    [self.tabGoodDetail registerNib:[UINib nibWithNibName:KGoodSdetailHeaderViewCell bundle:nil] forCellReuseIdentifier:KGoodSdetailHeaderViewCell];
    [self.tabGoodDetail reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.detailModel.commentList.count;
            break;
        case 2:
            return 1;
            break;
            
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseGoodSDetailViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:KGoodSdetailHeaderViewCell];
        [cell loadDataWithModel:self.detailModel];
    }else if(indexPath .section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:KGoodSDetailBackViewCell];
        [cell loadDataWithModel:self.detailModel.commentList[indexPath.row]];
    }else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:KGoodSdetailBottomViewCell];
        [cell loadDataWithModel:nil];
    }
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  KscreenWidth + 90;
    }else if (indexPath.section == 1){
        return [self.detailModel.commentList[indexPath.row] getCellHeight];
    }else if(indexPath.section == 2){
         return 400;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return [[GoodsDetailHeader alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
    }else{
        return [UIView new];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }else{
        return 0.1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isDrag = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isDrag == NO) {
        return;
    }
    if (scrollView.contentOffset.y  < KscreenWidth + 90) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setTitleViewState:goodsView];
        });
        
    }
    if (scrollView.contentOffset.y  > KscreenWidth + 90 && scrollView.contentOffset.y < self.tabGoodDetail.contentSize.height - KscreenHeight - 50) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setTitleViewState:commView];
        });
    }
    if (scrollView.contentOffset.y > self.tabGoodDetail.contentSize.height - KscreenHeight - 50) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self setTitleViewState:detailView];
        });
    }
}

-(void)setTitleViewState:(UIButton *)sender{
    goodsView.selected=  NO;
    commView.selected=  NO;
    detailView.selected=  NO;
    sender.selected = YES;
}

-(void)refreshUI {
    RequestReachabilityStatus status = [RequestManager reachabilityStatus];
    switch (status) {
        case RequestReachabilityStatusReachableViaWiFi:
        case RequestReachabilityStatusReachableViaWWAN: {
            [self requestGoodsDetailData];
        }
            break;
        default: {
        }
            break;
    }
}

-(void)requestGoodsDetailData {
    
    NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.goodsM.itemid forKey:@"itemid"];
    //请求数据
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, GoodsDetailUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            [self.loadingView stopAnimation];
            if ([dic[@"message"] containsString:@"该商品不存在"]) {
                [self showNoticeView:dic[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            [self showNoticeView:dic[@"message"]];
            return ;
        }
        self.detailModel = [[GoodDetailModel alloc]initWith:dic[@"data"]];
        [self.tabGoodDetail reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
}
- (IBAction)actionGoBuy:(id)sender {
    SCConfirmOrderVC *confirmOrder = [[SCConfirmOrderVC alloc] init];
    NSDictionary *goodsDict = [self.detailModel mj_keyValues];
    confirmOrder.goodsDict = goodsDict;
    confirmOrder.isdlbitem = @"1";
    [self.navigationController pushViewController:confirmOrder animated:YES];
}
- (IBAction)actionAddShopping:(id)sender {

            
            NSLog(@"加入购物车");
//    if (self.detailModel.itemid == nil  || self.detailModel.price) {
//        [self.loadingView showNoticeView:@"商品信息有误"];
//        return;
//    }
            NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
    NSString* itemsStr  = [NSString stringWithFormat:@"%@",@[@{@"itemid":self.detailModel.itemid,@"num":@"1",@"chose":@"0"}]];
            [pramaDic setObject:@"items" forKey:itemsStr];
            NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddToShoppingCarUrl];
            
            [self.view addSubview:self.loadingView];
            [self.loadingView startAnimation];
            
            [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
                [self.loadingView stopAnimation];
                NSDictionary *dic = json;
                NSString * status = [dic valueForKey:@"code"];
                if ([status intValue] != 200) {
                    [self showNoticeView:[dic valueForKey:@"message"]];
                    return ;
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"AddToShoppingCarSuccess" forKey:@"SCChangedShopingCar"];
                [self showNoticeView:@"亲，在购物车等你哦"];
            } failure:^(NSError *error) {
                [self.loadingView stopAnimation];
                if (error.code == -1009) {
                    [self showNoticeView:NetWorkNotReachable];
                }else{
                    [self showNoticeView:NetWorkTimeout];
                }
            }];
}


- (IBAction)actionHomeView:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
