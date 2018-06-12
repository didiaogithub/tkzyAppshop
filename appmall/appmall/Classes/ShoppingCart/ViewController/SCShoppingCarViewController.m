//
//  SCShoppingCarViewController.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCShoppingCarViewController.h"
#import "GoodModel.h"
#import "SCShoppingCarCell.h"
#import "OrderBottomView.h"
#import "SCSCConfirmOrderViewController.h"
#import "XWAlterVeiw.h"
#import "SCGoodsDetailViewController.h"
#import "SCShoppingCarNoDataView.h"
#import "GoodsDetailViewController.h"


@interface SCShoppingCarViewController ()<UITableViewDelegate, UITableViewDataSource, SCShoppingCarCellDelegate, OrderBottomViewDelegate, XWAlterVeiwDelegate,XYTableViewDelegate>

@property (nonatomic, strong) OrderBottomView *bottomView;
@property (nonatomic, strong) XWAlterVeiw *deleteAlertView;
@property (nonatomic, strong) UITableView *shoppingCarTableView;
@property (nonatomic, strong) GoodModel *goodModel;
@property (nonatomic, strong) NSMutableArray<GoodModel *> *shoppingCarDataArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *selectedRowArr;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) NSInteger deleteRow;

@end

@implementation SCShoppingCarViewController





-(NSMutableArray *)shoppingCarDataArray{
    if (_shoppingCarDataArray == nil) {
        _shoppingCarDataArray = [[NSMutableArray alloc] init];
    }
    return _shoppingCarDataArray;
}

-(NSMutableArray *)selectedArray{
    if (_selectedArray == nil) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

-(NSMutableArray *)selectedRowArr {
    if (_selectedRowArr == nil) {
        _selectedRowArr = [NSMutableArray array];
    }
    return _selectedRowArr;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _deleteRow = 0;
    
//    NSString *str = [KUserdefaults objectForKey:@"CKYS_RefreshCar"];
//    if (IsNilOrNull(str)) {
//        [self loadCacheData];
//    }else{
        [self getshoppingCarData];
//    }
    
    NSString *changedShoppingCar = [[NSUserDefaults standardUserDefaults] objectForKey:@"SCChangedShopingCar"];
    if ([changedShoppingCar isEqualToString:@"AddToShoppingCarSuccess"]) {
        [self getshoppingCarData];
        [[NSUserDefaults standardUserDefaults] setObject:@"Changed" forKey:@"SCChangedShopingCar"];
    }
    
    if (self.navigationController.viewControllers.count == 1) {

//        _shoppingCarTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 164);
//        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_shoppingCarTableView.frame), SCREEN_WIDTH, 50);

        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-49-BOTTOM_BAR_HEIGHT);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.shoppingCarTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
            make.left.right.mas_offset(0);
            make.bottom.equalTo(_bottomView.mas_top);
        }];
        
    }else{
//        _shoppingCarTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 164 + 50);
//        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_shoppingCarTableView.frame), SCREEN_WIDTH, 50);
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-BOTTOM_BAR_HEIGHT);
            make.left.right.mas_offset(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.shoppingCarTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
            make.left.right.mas_offset(0);
            make.bottom.equalTo(_bottomView.mas_top);
        }];
    }
    
    //请求我的优惠券列表
    [[SCCouponTools shareInstance] resquestMyCouponsData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [CKCNotificationCenter addObserver:self selector:@selector(defaultTableViewFrame) name:@"HasNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(changeTableViewFrame) name:@"NoNetNotification" object:nil];
    [CKCNotificationCenter addObserver:self selector:@selector(requestDataWithoutCache) name:@"RequestShoppingCarData" object:nil];

    
    [self createTableView];
    [self getshoppingCarData];
}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"购物车默认"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"去添加点什么呢";
    return str;
}


#pragma mark-请求购物车数据
-(void)getshoppingCarData{
    RLMResults *result = [GoodModel allObjectsInRealm:self.realm];
    
    if (result.count > 0) {
        [self.realm beginWriteTransaction];
        [self.realm deleteObjects:result];
        [self.realm commitWriteTransaction];
    }
    
    [self.shoppingCarDataArray removeAllObjects];
    [self.selectedRowArr removeAllObjects];
    [self.shoppingCarTableView reloadData];
    
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, GetShoppingCarUrl];
    NSDictionary *pramaDic= [HttpTool getCommonPara];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        [self.shoppingCarTableView.mj_header endRefreshing];
        NSDictionary *itemDic = json;
        if ([itemDic[@"code"] integerValue] != 200) {
            [self.loadingView stopAnimation];
            [self.loadingView showNoticeView:itemDic[@"message"]];
            return;
        }
        
        [KUserdefaults removeObjectForKey:@"CKYS_RefreshCar"];
        
        NSArray *itemArr = itemDic[@"data"][@"cartList"];
        if ([itemArr isKindOfClass:[NSArray class]]) {
            if (itemArr.count == 0) {
                [self.shoppingCarDataArray removeAllObjects];
                [self.shoppingCarTableView reloadData];
                
                _editBtn.enabled = NO;
                
            }

            
            for (NSDictionary *goodDic in itemArr) {
                GoodModel *model = [[GoodModel alloc]initWith:goodDic];
                model.itemid = [NSString stringWithFormat:@"%@", model[@"itemid"]];
                model.imgpath = [NSString stringWithFormat:@"%@", goodDic[@"imgpath"]];
                model.name = [NSString stringWithFormat:@"%@", goodDic[@"name"]];
                model.price = [NSString stringWithFormat:@"%@", goodDic[@"price"]];
                model.spec = [NSString stringWithFormat:@"%@",goodDic[@"spec"]];
                model.chose = [NSString stringWithFormat:@"%@",goodDic[@"chose"]];
                model.num = [NSString stringWithFormat:@"%@",goodDic[@"num"]];
                model.no = [NSString stringWithFormat:@"%@",goodDic[@"no"]];
                model.isSelect = NO;
                [self.shoppingCarDataArray addObject:model];
            }
            
            for (NSInteger i = 0; i < self.shoppingCarDataArray.count; i++) {
                GoodModel *classM = self.shoppingCarDataArray[i];
                
                [self.realm beginWriteTransaction];
                [GoodModel createOrUpdateInRealm:self.realm withValue:classM];
                [self.realm commitWriteTransaction];
            }
        }else{
            [self.shoppingCarDataArray removeAllObjects];
            [self.shoppingCarTableView reloadData];
            _editBtn.enabled = NO;
        }
        _bottomView.realPayMoneyLable.text = @"合计:￥0.00";
        _bottomView.allSelectedButton.selected = NO;
       
        [self loadCacheData];
        [self.shoppingCarTableView reloadData];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.shoppingCarTableView.mj_header endRefreshing];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        if(self.shoppingCarDataArray.count == 0){
            _editBtn.enabled = NO;
            
        }else{
            _editBtn.enabled = YES;
        }
    }];
}

#pragma mark - 加载缓存
-(void)loadCacheData {

    RLMResults *results = [GoodModel allObjectsInRealm:self.realm];// [GoodModel allObjectsInRealm:self.realm];
    [self.shoppingCarDataArray removeAllObjects];
    if (results.count > 0) {
        for (GoodModel *cls in results) {
            [self.shoppingCarDataArray addObject:cls];
        }
        [self.shoppingCarTableView.mj_header endRefreshing];
        [self.shoppingCarTableView.mj_footer endRefreshing];
        [self.shoppingCarTableView reloadData];
        _editBtn.enabled = YES;
    }else{
        _editBtn.enabled = NO;

    }
}

-(void)createTableView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.shoppingCarTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.shoppingCarTableView.delegate  = self;
    self.shoppingCarTableView.dataSource = self;
    self.shoppingCarTableView.rowHeight = UITableViewAutomaticDimension;
    self.shoppingCarTableView.estimatedRowHeight = 44;
    self.shoppingCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.shoppingCarTableView];
    
    [self.shoppingCarTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
     _shoppingCarTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 164-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    
    _bottomView = [[OrderBottomView alloc] initWithFrame:CGRectZero andType:@"yes"];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_shoppingCarTableView.frame), SCREEN_WIDTH, 50);
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 45);
    _editBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    _editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:TitleColor forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_editBtn setTitleColor:[UIColor tt_redMoneyColor] forState:UIControlStateSelected];
    
    _editBtn.enabled = NO;
    
    [_editBtn addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitleColor:SubTitleColor forState:UIControlStateNormal];
    
//    if (@available(iOS 11.0, *)) {
//        _editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, -20);
//        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
//        self.navigationItem.rightBarButtonItem = editItem;
//    }else{
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -20;
        self.navigationItem.rightBarButtonItems = @[spaceItem, editItem];
//    }
}

-(void)clickEditButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected){
        _bottomView.realPayMoneyLable.hidden = YES;
        _bottomView.deleteButton.hidden = NO;
        _bottomView.collectedButton.hidden = NO;
    }else{
        _bottomView.realPayMoneyLable.hidden = NO;
        _bottomView.deleteButton.hidden = YES;
        _bottomView.collectedButton.hidden = YES;
    }
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shoppingCarDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SCShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCShoppingCarCell"];
    if (cell == nil) {
        cell = [[SCShoppingCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCShoppingCarCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.indexRow = indexPath.row;
    if ([self.shoppingCarDataArray count]) {
        _goodModel = [self.shoppingCarDataArray objectAtIndex:indexPath.row];
        [cell setModel:_goodModel];
    }
    
    __weak typeof(self) weakSelf = self;
    [cell setBlock:^(GoodModel *model, NSInteger row) {
        NSLog(@"加减号传过来的名字:%@数量:%@ ",model.name, model.num);
        [weakSelf numPrice:self.shoppingCarDataArray[row] andtype:@"0" andnum:model.num];
        //加减号操作，删除操作，移动到收藏夹操作，立即购买操作，离开页面后要更新购物车数据。
//        [KUserdefaults setObject:@"YES" forKey:@"ifNeedUpdateShoppingCar"];
    }];
    return cell;
}




#pragma mark-计算总价格
- (void)numPrice:(GoodModel*)models andtype:(NSString *)type andnum:(NSString *)numCount {
    NSDecimalNumber *num = [[NSDecimalNumber alloc] initWithString:@"0.00"];
    NSString *result = nil;
    for (int i=0; i<self.shoppingCarDataArray.count; i++) {
        models = [self.shoppingCarDataArray objectAtIndex:i];
        NSString *pricestr = [NSString stringWithFormat:@"%@",models.price];
        NSString *localCountStr = [NSString stringWithFormat:@"%@",numCount];
        if (IsNilOrNull(localCountStr)) {
            localCountStr = @"1";
        }
        NSInteger count = [localCountStr integerValue];
        NSString *indexStr = [NSString stringWithFormat:@"%d", i];
        
        if (models.isSelect) {
            if (![self.selectedRowArr containsObject:indexStr]) {
                [self.selectedRowArr addObject:indexStr];
            }
            
            num = SNAdd(SNMul(@(count), pricestr), num);
            NSLog(@"pricestr:%@*count:%ld =totalMoney:%@", pricestr, (long)count, num);
            result = [NSString stringWithFormat:@"%@",num];
            
            
        }else{
            
            if ([self.selectedRowArr containsObject:indexStr]) {
                [self.selectedRowArr removeObject:indexStr];
            }
        }
        
    }
    if (IsNilOrNull(result)) {
        result = @"0.00";
    }
    double total = [result doubleValue];
    _bottomView.realPayMoneyLable.text = [NSString stringWithFormat:@"合计:¥%.2f", total];
}

#pragma mark-点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.shoppingCarDataArray count]){
        _goodModel = self.shoppingCarDataArray[indexPath.row];
    }
    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc] init];
    detailVc.goodsId = _goodModel.itemid;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark-点击单选按钮 代理方法
-(void)singleClick:(GoodModel *)goodModel anRow:(NSInteger)indexRow andSection:(NSInteger)section{
    
    NSLog(@"单选传过来的 名字 %@数量%@ ",goodModel.name,goodModel.num);
    NSMutableArray *array =  [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0;i<self.shoppingCarDataArray.count;i++) {
        goodModel  = [self.shoppingCarDataArray objectAtIndex:i];
        NSString *indexStr = [NSString stringWithFormat:@"%ld", indexRow];
        if (goodModel.isSelect){
            [array addObject:goodModel];
            if (array.count == self.shoppingCarDataArray.count) {
                _bottomView.allSelectedButton.selected = YES;
            }
        }else{
            if ([self.selectedRowArr containsObject:indexStr]) {
                [self.selectedRowArr removeObject:indexStr];
            }
            _bottomView.allSelectedButton.selected = NO;
        }
    }
   goodModel =  self.shoppingCarDataArray[indexRow];
    [self numPrice:goodModel andtype:@"0" andnum:goodModel.num];
    //一个cell刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:section]; //刷新第0段第2行
    [self.shoppingCarTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        [self.carrySelfTableView reloadData];
    
}
#pragma mark-点击bottomView代理方法全选788  点击立即购买 789
-(void)bottomViewButtonClicked:(UIButton *)button{
    NSInteger buttonTag = button.tag -788;
    if (buttonTag == 0){
        button.selected = !button.selected;
        BOOL btselected = button.selected;
        for (int i =0; i<self.shoppingCarDataArray.count; i++) {
            
            _goodModel = [self.shoppingCarDataArray objectAtIndex:i];
            
            GoodModel *classM = [[GoodModel alloc] init];
            classM.itemid = _goodModel.itemid;
            
            classM.price = _goodModel.price;
            classM.num = @"1";
            classM.spec = _goodModel.spec;
            classM.imgpath = _goodModel.imgpath;
            classM.name = _goodModel.name;
            classM.no =_goodModel.no;
            classM.isSelect =NO;
            if (btselected){
                classM.isSelect = YES;
                
                
                [self.realm beginWriteTransaction];
                [GoodModel createOrUpdateInRealm:self.realm withValue:classM];
                [self.realm commitWriteTransaction];
            }else{
                classM.isSelect = NO;
                
                
                [self.realm beginWriteTransaction];
                [GoodModel createOrUpdateInRealm:self.realm withValue:classM];
                [self.realm commitWriteTransaction];
            }
            [self numPrice:_goodModel andtype:@"1" andnum:_goodModel.num];
            [self.shoppingCarTableView reloadData];
        }
    }else{
        [self.selectedArray removeAllObjects];
        for (int i = 0;i<self.shoppingCarDataArray.count;i++) {
            _goodModel = [self.shoppingCarDataArray objectAtIndex:i];
            if (_goodModel.isSelect) {//选中
                [self.selectedArray addObject:_goodModel];
            }
        }
        if (![self.selectedArray count]) {
            [self.loadingView showNoticeView:@"请先选择商品"];
            return;
        }
        if (buttonTag == 1) {
            
            [self clickBuyUpdateShoppingCar]; // 目前是后台清除购物车
            
        }else if (buttonTag == 2){
            _deleteAlertView = [[XWAlterVeiw alloc] init];
            _deleteAlertView.delegate = self;
            _deleteAlertView.titleLable.text = @"确定从购物车中删除吗？";
            _deleteAlertView.type = @"编辑删除";
            [_deleteAlertView show];
            
        }else{
            NSLog(@"移动到收藏夹");
            [self addGoodsToMyCollection];
        }
    }
}

-(void) clickBuyUpdateShoppingCar {
    RLMResults *results = [[CacheData shareInstance] search:[GoodModel class]];
    NSMutableArray *cartlist = [NSMutableArray array];
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    for (GoodModel *goodsM in results) {
        
        NSString *status = @"0";
        if (goodsM.isSelect == YES) {
            status = @"1";
        }
        NSDictionary *dic = @{@"itemid":goodsM.itemid, @"num":goodsM.num, @"chose":status};
        [cartlist addObject:dic];
    }
    NSString *itemsStr = [cartlist mj_JSONString];
    [pramaDic setObject:itemsStr forKey:@"items"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, UpdateShoppingCarInfoUrl];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
//    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
//        [self.loadingView stopAnimation];
//        NSDictionary *dic = json;
//        if ([dic[@"code"] integerValue] !=  200) {
//            [self.loadingView showNoticeView:dic[@"message"]];
//            return ;
//        }
        SCSCConfirmOrderViewController *sureMySelf = [[SCSCConfirmOrderViewController alloc]init];
        sureMySelf.goodOrderModel = _goodModel;
        sureMySelf.allMoneyString = _bottomView.realPayMoneyLable.text;
        sureMySelf.dataArray = self.selectedArray;        
        [self.navigationController pushViewController:sureMySelf animated:YES];
//    } failure:^(NSError *error) {
//        [self.loadingView stopAnimation];
//        NSLog(@"%@", error);
//    }];
}

-(void)subuttonClicked {
    if ([_deleteAlertView.type isEqualToString:@"编辑删除"]) {
        NSString *itemids = @"";
        NSMutableArray *itemsArr = [NSMutableArray array];
        
        for (GoodModel *goodsM in self.selectedArray) {
            NSString *goodsid = [NSString stringWithFormat:@"%@", goodsM.itemid];
            [itemsArr addObject:goodsid];
        }
        
        itemids = [itemsArr componentsJoinedByString:@","];
        
        NSArray *result = [self.selectedRowArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1]; //升序
            
        }];
        NSLog(@"result=%@",result);
        [self deleteShoppingCarGoods:itemids indexArr:result];
    }else if ([_deleteAlertView.type isEqualToString:@"左滑删除"]) {
        GoodModel *goodsM = [[GoodModel alloc] init];
        goodsM = self.shoppingCarDataArray[_deleteRow];
        //itemids：一组商品id，逗号分隔
        NSString *itemids = [NSString stringWithFormat:@"%@", goodsM.itemid];
        NSString *indexStr = [NSString stringWithFormat:@"%ld", _deleteRow];
        [self deleteShoppingCarGoods:itemids indexArr:@[indexStr]];
    }
}

#pragma makr-左滑删除
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self setEditing:true animated:true];
        
        _deleteRow = indexPath.row;
        _deleteAlertView = [[XWAlterVeiw alloc] init];
        _deleteAlertView.delegate = self;
        _deleteAlertView.titleLable.text = @"确定从购物车中删除吗？";
        _deleteAlertView.type = @"左滑删除";
        [_deleteAlertView show];
    };
    
    UITableViewRowAction *delectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    return @[delectRowAction];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [self setEditing:true animated:true];
    
}

#pragma mark - 删除购物车商品
-(void)deleteShoppingCarGoods:(NSString*)itemids indexArr:(NSArray*)indexArr{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI, DelShoppingCarUrl];
   
    NSMutableDictionary *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:itemids forKey:@"itemids"];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] !=  200) {
            [self.loadingView stopAnimation];
            [self.loadingView showNoticeView:dic[@"message"]];
            return ;
        }
        for (NSString *index in indexArr) {
            if (self.shoppingCarDataArray.count > [index integerValue]) {
                [self.shoppingCarDataArray removeObjectAtIndex:[index integerValue]];
            }
        }
        [self.shoppingCarTableView reloadData];
        
        [self.selectedRowArr removeAllObjects];
        
        [self getshoppingCarData];
        [self.loadingView showNoticeView:@"删除成功"];
        //加减号操作，删除操作，移动到收藏夹操作，立即购买操作，离开页面后要更新购物车数据。
        [KUserdefaults setObject:@"YES" forKey:@"ifNeedUpdateShoppingCar"];
        [self.loadingView stopAnimation];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        [self.shoppingCarTableView.mj_header endRefreshing];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
    }];
}

#pragma mark - 添加到收藏夹
-(void)addGoodsToMyCollection {
    
    NSArray *result = [self.selectedRowArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //升序
        
    }];
    
    NSMutableArray *idArr = [NSMutableArray array];
    for (GoodModel *goodsM in self.selectedArray) {
        [idArr addObject:[NSString stringWithFormat:@"%@", goodsM.itemid]];
    }
    
    NSString *itemids = [idArr componentsJoinedByString:@","];
    NSMutableDictionary *pramaDic= [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:itemids forKey:@"itemid"];
    NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddCollectionUrl];
    [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
        NSDictionary *dic = json;
        NSString * status = [dic valueForKey:@"code"];
        if ([status intValue] != 200) {
            [self.loadingView showNoticeView:[dic valueForKey:@"message"]];
            return ;
        }
        
        for (NSString *index in result) {
            if (self.shoppingCarDataArray.count > [index integerValue]) {
                [self.shoppingCarDataArray removeObjectAtIndex:[index integerValue]];
            }
        }
        
        [self.shoppingCarTableView reloadData];
        
        [self.selectedRowArr removeAllObjects];
        [self.loadingView showNoticeView:@"收藏成功"];
        [self deleteShoppingCarGoods:itemids indexArr:result];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //加减号操作，删除操作，移动到收藏夹操作，立即购买操作，离开页面后要更新购物车数据。
    NSString *ifNeedUpdateShoppingCar = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"ifNeedUpdateShoppingCar"]];
    if ([ifNeedUpdateShoppingCar isEqualToString:@"YES"]) {
        [self updateShoppingCarData];
        [KUserdefaults setObject:@"NO" forKey:@"ifNeedUpdateShoppingCar"];
    }
}

-(void)updateShoppingCarData {
    
    RLMResults *results = [[CacheData shareInstance] search:[GoodModel class]];
    [self.shoppingCarDataArray removeAllObjects];
    
    NSMutableArray *cartlist = [NSMutableArray array];
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    for (GoodModel *goodsM in results) {
        
        NSString *status = @"0";
        if (goodsM.isSelect == YES) {
            status = @"1";
        }
        NSDictionary *dic = @{@"itemid":goodsM.itemid, @"num":goodsM.num, @"chose":status};
        [cartlist addObject:dic];
    }
    NSString *itemsStr = [cartlist mj_JSONString];
    [pramaDic setObject:itemsStr forKey:@"items"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, UpdateShoppingCarInfoUrl];
    
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
    } failure:^(NSError *error) {
    }];
}

-(void)defaultTableViewFrame {
//    _shoppingCarTableView.frame = CGRectMake(0, 64+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 150-NaviAddHeight-BOTTOM_BAR_HEIGHT);
    [self.shoppingCarTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

-(void)changeTableViewFrame {
    [self.shoppingCarTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+NaviAddHeight+44);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

-(void)requestDataWithoutCache {
    [self getshoppingCarData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
