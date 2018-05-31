//
//  ArrearsManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsManagerViewController.h"
#import "ArrearsTableCell.h"
#import "ArrearsFooterView.h"
#import "ArrearsHeaderView.h"

@interface ArrearsManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) NSMutableArray *orderDataArr;
@property (nonatomic, strong) UIButton *applyingButton; //申请中
@property (nonatomic, strong) UIButton *refusedButton; //已拒绝
@property (nonatomic, strong) UIButton *waitPayButton; //待还款
@property (nonatomic, strong) UIButton *afterPayButton; //已还款
@property (nonatomic, strong) NSMutableArray *statusBtnArr;
@property (nonatomic, strong) UILabel *indicateLine;
@property (nonatomic, strong) NSArray *statusArr;
@property (nonatomic, copy)  NSString *statusString;
/**  dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**  tableView*/
@property (nonatomic, strong) UITableView *mtableView;
@end

@implementation ArrearsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欠款管理";
    _statusArr = @[@"1", @"2,7", @"4,5", @"99"];
     [self createTopButton];
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.dataArray = [NSMutableArray array];
    [self getData];
}


- (void)getData{
    NSDictionary * pramaDic = [HttpTool getCommonPara];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMyLoanList];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSArray *Arr = dict[@"data"][@"orders"];
        for (NSDictionary *dic in Arr) {

        }
        
        [self.mtableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}


/**创建订单状态按钮*/
-(void)createTopButton{
    self.statusView = [[UIView alloc] init];
    self.statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(50);
    }];
    float buttonH = 50;
    _statusBtnArr = [NSMutableArray array];
    NSArray *titleArr = @[@"申请中", @"已拒绝", @"待还款", @"已还款"];
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [self createOrderButtonWithframe:CGRectMake((SCREEN_WIDTH/4)*i, 0, SCREEN_WIDTH/4, buttonH) andTag:140+i andAction:@selector(clickOrderButton:) andtitle:titleArr[i]];
        [self.statusView addSubview:btn];
        [_statusBtnArr addObject:btn];
    }
    
    self.indicateLine = [[UILabel alloc] init];
    self.indicateLine.backgroundColor = [UIColor tt_redMoneyColor];
    [self.statusView addSubview:self.indicateLine];
    [self.indicateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(47);
        make.left.mas_offset(20);
        make.width.mas_offset(SCREEN_WIDTH/4 - 40);
        make.height.mas_offset(3);
    }];
    
}

/**创建 统一 button*/
-(UIButton *)createOrderButtonWithframe:(CGRect)frame andTag:(NSInteger)tag andAction:(SEL)action andtitle:(NSString *)title{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TitleColor forState:UIControlStateNormal];
    button.titleLabel.font = MAIN_TITLE_FONT;
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    switch (tag-140) {
        case 0:
            _applyingButton = button;
            break;
        case 1:
            _refusedButton = button;
            break;
        case 2:
            _waitPayButton = button;
            break;
        case 3:
            _afterPayButton = button;
            break;
        default:
            break;
    }
    
    return button;
}


-(void)clickOrderButton:(UIButton *)button{
  
    
    [self updateBtnSelectedState:button];
}
-(void)updateBtnSelectedState:(UIButton*)button {
    for (NSInteger i = 0; i < _statusBtnArr.count; i++) {
        UIButton *btn = _statusBtnArr[i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    self.statusString = _statusArr[button.tag - 140];
    [self moveStatusLineWithStatus:self.statusString];
    button.selected = YES;
    [button setUserInteractionEnabled:NO];
}


//移动红线
-(void)moveStatusLineWithStatus:(NSString *)status{
    
    
    float leftX = 20;
    if ([self.statusString isEqualToString:@"1"]){//申请中
        leftX = 20;
    }else if ([self.statusString isEqualToString:@"2,7"]){//已拒绝
        leftX = SCREEN_WIDTH/4 + 20;
    }else if ([self.statusString isEqualToString:@"4,5"]){//已还款
        leftX = SCREEN_WIDTH*2/4 + 20;
    }else{ //99:全部
        leftX = SCREEN_WIDTH*3/4 + 20; // 待还款
    }
    [self.indicateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftX);
    }];
}
#pragma mark ---- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    InvoicesManagerModel *model = self.dataArray[section];
//
//    return model.ordersheet.count;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 103;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InvoicesManagerCell";//这个identifier跟xib设置的一样
    ArrearsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]
                loadNibNamed:@"ArrearsTableCell" owner:self options:nil]  lastObject];
    }
//    InvoicesManagerModel *model = self.dataArray[indexPath.section];
//    NSArray *ordersheet = model.ordersheet;
//    [cell refreshData:ordersheet[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ArrearsHeaderView *view = [[ArrearsHeaderView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    InvoicesManagerModel *model = self.dataArray[section];
//    view.orderNum.text = [NSString stringWithFormat:@"订单编码:%@",model.orderno];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ArrearsFooterView *view = [[ArrearsFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
   
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}



@end
