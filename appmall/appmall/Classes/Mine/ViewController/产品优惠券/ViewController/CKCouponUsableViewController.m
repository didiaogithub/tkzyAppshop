//
//  CKCouponUsableViewController.m
//  appmall
//
//  Created by majun on 2018/6/4.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//
// 可用的优惠券
#import "CKCouponUsableViewController.h"
#import "CKCouponCannotUseCell.h"
#import "CKCouponModel.h"
#import "UITableView+XY.h"
#import "SCSCConfirmOrderViewController.h"

@interface CKCouponUsableViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate>
@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, strong) NSMutableArray *cannotUseArray;
@property (nonatomic, copy)   NSString *couponType;
@end

@implementation CKCouponUsableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"可用产品券";
    self.couponType = @"0";
    [self initComponents];
    [self resquestCouponData:@"0"];
}

#pragma mark - 获取创客的充值抵用券列表
-(void)resquestCouponData:(NSString*)lineNumber {
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Goods/getCouponList"];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    if ([self.ordermoney containsString:@"合计:¥"]) {
        self.ordermoney = [self.ordermoney substringFromIndex:4];
    }
    [pramaDic setObject:self.couponType forKey:@"type"];
    [pramaDic setObject:self.ordermoney forKey:@"ordermoney"];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self.couponTable.mj_header endRefreshing];
            [self.couponTable.mj_footer endRefreshing];
            [self showNoticeView:dict[@"codeinfo"]];
            return ;
        }
        
        NSArray *list = dict[@"data"][@"list"];
        
            if ([lineNumber isEqualToString:@"0"]) {
                [self.cannotUseArray removeAllObjects];
            }
            for (NSDictionary *couponDic in list) {
                CKCouponModel *couponM = [[CKCouponModel alloc] init];
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.cannotUseArray addObject:couponM];
            }
            _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        
        [self.couponTable reloadData];
        [self.couponTable.mj_header endRefreshing];
        if (list.count > 0) {
            [self.couponTable.mj_footer endRefreshing];
        }else{
            [self.couponTable.mj_footer endRefreshingWithNoMoreData];
        }
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.couponTable.mj_header endRefreshing];
        [self.couponTable.mj_footer endRefreshing];
        [self.loadingView stopAnimation];
    
        _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        [self.couponTable reloadData];
    }];
}


-(void)initComponents {
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviAddHeight + 20);
        make.height.mas_equalTo(46);
    }];

    self.couponTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.couponTable.delegate = self;
    self.couponTable.dataSource = self;
    self.couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.couponTable.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        self.couponTable.estimatedSectionHeaderHeight = 10;
        self.couponTable.estimatedSectionFooterHeight = 0.1;
    }
    [self.view addSubview:self.couponTable];
    [self.couponTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(tagView.mas_bottom).offset(0);
        make.bottom.mas_offset(-BOTTOM_BAR_HEIGHT);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return self.cannotUseArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        CKCouponCannotUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKCouponCannotUseCell"];
        if (!cell) {
            cell = [[CKCouponCannotUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKCouponCannotUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CKCouponModel *couponM = self.cannotUseArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cannotUseArray == nil) {
        return;
    }
    // 这里处理点击优惠券带回金额
    CKCouponModel *couponM = self.cannotUseArray[indexPath.section];
    if (_couponBlock) {
        _couponBlock(couponM.money, couponM.couponId);
    }

    [self.navigationController popViewControllerAnimated:YES];
        
}


-(void)setCouponBlock:(CouponBlock)couponBlock {
    _couponBlock = couponBlock;
}


- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"产品券默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"多关注我们享有更多产品券哦";
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)cannotUseArray{
    if (!_cannotUseArray) {
        _cannotUseArray = [NSMutableArray array];
    }
    return _cannotUseArray;
}



@end
