//
//  CKCouponDetailViewController.m
//  CKYSPlatform
//
//  Created by majun on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "CKCouponDetailViewController.h"
#import "CKCouponModel.h"
#import "CKCouponCannotUseCell.h"
#import "CKCouponCanUseCell.h"
#import "CKCouponNotCanUseCell.h"
#import "UITableView+XY.h"
#import "SCSCConfirmOrderViewController.h"
@interface CKCouponDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate>

@property (nonatomic, strong) UIButton *canUseBtn; // 未使用
@property (nonatomic, strong) UIButton *canNotUseBtn; // 已使用
@property (nonatomic, strong) UIButton *notCanUseBtn; // 已过期
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UITableView *couponTable;
@property (nonatomic, strong) UIImageView *noData;
@property (nonatomic, strong) UILabel *noDataLabel;


@property (nonatomic, strong) NSMutableArray *cannotUseArray;
@property (nonatomic, strong) NSMutableArray *usedArray;
@property (nonatomic, strong) NSMutableArray *expireArray;
@property (nonatomic, copy)   NSString *couponType;
@end

@implementation CKCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"产品券";
    self.couponType = @"0";
    
    
     [self initComponents];
     [self resquestCouponData:@"0"];
    
    
    NSArray *couponListArray = [[XNArchiverManager shareInstance] xnUnarchiverObject:[NSString stringWithFormat:@"MJCouponCache_%@", self.couponType]];
    if (couponListArray.count > 0) {
        for (NSDictionary *couponDic in couponListArray) {
            CKCouponModel *couponM = [[CKCouponModel alloc] init];
            [couponM setValuesForKeysWithDictionary:couponDic];
            [self.cannotUseArray addObject:couponM];
        }
        _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        [self.couponTable reloadData];
    }

}



- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"产品券默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"多关注我们享有更多产品券哦";
    return str;
}


-(void)initComponents {

    UIView *tagView = [UIView new];
    tagView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.view.mas_top).offset(NaviAddHeight+64);
        make.height.mas_equalTo(46);
    }];
    
    self.canUseBtn = [[UIButton alloc] init];
    [self.canUseBtn setTitle:@"待使用" forState:UIControlStateNormal];
    [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
    self.canUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.canUseBtn];
    self.canUseBtn.tag = 44;
    [self.canUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#E2231A"];
    self.lineLabel.frame = CGRectMake((SCREEN_WIDTH / 3 - 100) * 0.5, 44, 100, 2);
    [tagView addSubview:self.lineLabel];
    
    self.canNotUseBtn = [[UIButton alloc] init];
    [self.canNotUseBtn setTitle:@"已过期" forState:UIControlStateNormal];
    [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.canNotUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.canNotUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.canNotUseBtn];
    self.canNotUseBtn.tag = 45;
    [self.canNotUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_canUseBtn.mas_right);
        make.top.mas_offset(AdaptedHeight(0));
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
    }];
    
    self.notCanUseBtn = [[UIButton alloc]init];
    [self.notCanUseBtn setTitle:@"已使用" forState:UIControlStateNormal];
    [self.notCanUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    self.notCanUseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.notCanUseBtn addTarget:self action:@selector(clickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:self.notCanUseBtn];
     self.notCanUseBtn.tag = 46;
    [self.notCanUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
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


- (void)clickTagBtn:(UIButton *)button{
    NSLog(@"%@", button.titleLabel.text);
    if (button.tag == 44) {
        [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [self.notCanUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake((SCREEN_WIDTH / 3 -100)*0.5, 44, 100, 2);
        }];
        self.couponType = @"0";
        
        if (self.cannotUseArray.count > 0) {
            _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData:@"0"];
        }
   
    }else if(button.tag == 45){
        [self.canUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [self.notCanUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.canNotUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake((SCREEN_WIDTH / 3 -100)*1.5 + 100, 44, 100, 2);
        }];
        
        self.couponType = @"2";
        
        if (self.expireArray.count > 0) {
            _noData.hidden = (self.expireArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.expireArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData:@"2"];
        }
       
       
    }else{
        [self.canUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [self.canNotUseBtn setTitleColor:TitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [self.notCanUseBtn setTitleColor:[UIColor colorWithHexString:@"#E2231A"] forState:UIControlStateNormal];
            self.lineLabel.frame = CGRectMake((SCREEN_WIDTH / 3 -100)*2.5 + 200, 44, 100, 2);
        }];
        self.couponType = @"1";
        
        if (self.usedArray.count > 0) {
            _noData.hidden = (self.usedArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.usedArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            //如果有值切换时不再请求
            [self resquestCouponData:@"1"];
        }
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.couponType isEqualToString:@"0"]) {
        return self.cannotUseArray.count;
    }
    
    if ([self.couponType isEqualToString:@"1"]) {
        return self.usedArray.count;
    }
    
    return self.expireArray.count;
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
    
    if ([self.couponType isEqualToString:@"0"]) {
        CKCouponCannotUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKCouponCannotUseCell"];
        if (!cell) {
            cell = [[CKCouponCannotUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKCouponCannotUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CKCouponModel *couponM = self.cannotUseArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        
        return cell;
    }else if([self.couponType isEqualToString:@"1"]){
        CKCouponCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKCouponCanUseCell"];
        if (!cell) {
            cell = [[CKCouponCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKCouponCanUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CKCouponModel *couponM = self.usedArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        return cell;
    }else{
        CKCouponNotCanUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKCouponNotCanUseCell"];
        if (!cell) {
            cell = [[CKCouponNotCanUseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKCouponNotCanUseCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CKCouponModel *couponM = self.expireArray[indexPath.section];
        [cell refreshCouponWithCouponModel:couponM];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 这里处理点击优惠券带回金额
    
    if (_couponBlock) {
        _couponBlock(self.coupontMoney, self.couponId);
    }
    
    if (self.isMyProductLib == YES) {
        return;
    }
    if ([self.couponType isEqualToString:@"0"]) {
        if (self.cannotUseArray == nil) {
            return;
        }
         CKCouponModel *couponM = self.cannotUseArray[indexPath.section];
        if (couponM == nil) {
            return;
        }
        NSString *money = [NSString stringWithFormat:@"%@",couponM.money];
        if (IsNilOrNull(money)) {
            money = @"";
        }
         UIViewController *VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        UIViewController *vc;
//        if ([VC isKindOfClass:[YunDouToProductViewController class]]) {
//             vc = (YunDouToProductViewController *)VC;
//            self.delegate = vc;
//            [self.delegate returnMoney:money couponId:couponM.voucherid];
//        }
//        if ([VC isKindOfClass:[TopUpViewController class]]){
//             vc = (TopUpViewController *)VC;
//            self.delegate = vc;
//            [self.delegate returnMoney:money couponId:couponM.voucherid];
//        }
        
        if ([VC isKindOfClass:[SCSCConfirmOrderViewController class]]) {
                         vc = (SCSCConfirmOrderViewController *)VC;
                        self.delegate = vc;
                        [self.delegate returnMoney:money couponId:couponM.couponId];
        }else{
            return;
        }
//        使用popToViewController返回并传值到上一页面
        [self.navigationController popToViewController:vc animated:true];
       
    }else{
        
    }
}


-(void)setCouponBlock:(CouponBlock)couponBlock {
    _couponBlock = couponBlock;
}

#pragma mark - 获取创客的充值抵用券列表
-(void)resquestCouponData:(NSString*)lineNumber {

//    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Center/getMyCouponList"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, @"Goods/getCouponList"];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.couponType forKey:@"type"];
//    NSDictionary *params = @{@"ckid":KCKidstring, @"voucherstatus":self.couponType, @"rowid":lineNumber, @"pagesize":@"50"};

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

        if ([self.couponType isEqualToString:@"0"]) {
            if ([lineNumber isEqualToString:@"0"]) {
                [self.cannotUseArray removeAllObjects];

                [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:[NSString stringWithFormat:@"MJCouponCache_%@", self.couponType]];
            }
            for (NSDictionary *couponDic in list) {
                CKCouponModel *couponM = [[CKCouponModel alloc] init];
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.cannotUseArray addObject:couponM];
            }
            _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
        }else if([self.couponType isEqualToString:@"1"]){
            if ([lineNumber isEqualToString:@"0"]) {
                [self.usedArray removeAllObjects];
                [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:[NSString stringWithFormat:@"MJCouponCache_%@", self.couponType]];
            }
            for (NSDictionary *couponDic in list) {
                CKCouponModel *couponM = [[CKCouponModel alloc] init];
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.usedArray addObject:couponM];
            }
            _noData.hidden = (self.usedArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.usedArray.count > 0) ? YES : NO;
        }else{
            if ([lineNumber isEqualToString:@"0"]) {
                [self.expireArray removeAllObjects];
                [[XNArchiverManager shareInstance] xnArchiverObject:list archiverName:[NSString stringWithFormat:@"MJCouponCache_%@", self.couponType]];
            }
            for (NSDictionary *couponDic in list) {
                CKCouponModel *couponM = [[CKCouponModel alloc] init];
                [couponM setValuesForKeysWithDictionary:couponDic];
                [self.expireArray addObject:couponM];
            }
            _noData.hidden = (self.expireArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.expireArray.count > 0) ? YES : NO;
        }

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
        if ([self.couponType isEqualToString:@"0"]){
            _noData.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.cannotUseArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else if([self.couponType isEqualToString:@"1"]){
            _noData.hidden = (self.usedArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.usedArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }else{
            _noData.hidden = (self.expireArray.count > 0) ? YES : NO;
            _noDataLabel.hidden = (self.expireArray.count > 0) ? YES : NO;
            [self.couponTable reloadData];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.couponType isEqualToString:@"0"]) {
        self.couponTable.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }
    
}


#pragma make --- lazy


- (NSMutableArray *)cannotUseArray{
    if (!_cannotUseArray) {
        _cannotUseArray = [NSMutableArray array];
    }
    return _cannotUseArray;
}

- (NSMutableArray *)usedArray{
    if (!_usedArray) {
        _usedArray = [NSMutableArray array];
    }
    return _usedArray;
}
- (NSMutableArray *)expireArray{
    if (!_expireArray) {
        _expireArray = [NSMutableArray array];
    }
    return _expireArray;
}

@end
