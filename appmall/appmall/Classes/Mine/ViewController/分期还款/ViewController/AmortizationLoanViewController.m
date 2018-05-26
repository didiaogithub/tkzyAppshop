//
//  AmortizationLoanViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AmortizationLoanViewController.h"
#import "AmortizationLoanCell.h"
#import "AmortizationHeadView.h"
#import "AmortizationLoan.h"
#import "Stag.h"
@interface AmortizationLoanViewController ()<UITableViewDelegate,UITableViewDataSource,AmortizationHeadViewDelegate>
{
    BOOL _isOpen[1000];
}


@property (weak, nonatomic) IBOutlet UITableView *mTableView;

/**  dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**  分区内数组*/
@property (nonatomic, strong) NSMutableArray *stagArray;


@end

@implementation AmortizationLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分期还款";
    self.dataArray = [NSMutableArray array];
    self.stagArray = [NSMutableArray array];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"AmortizationLoanCell" bundle:nil] forCellReuseIdentifier:@"AmortizationLoanCell"];

    [self getData];
}

- (void)getData{
    NSDictionary * pramaDic = [HttpTool getCommonPara];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMyDividePayList];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSArray *Arr = dict[@"data"][@"orders"];
        for (NSDictionary *dic in Arr) {
            AmortizationLoan *model = [[AmortizationLoan alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isOpen[section]) {
        AmortizationLoan *model = self.dataArray[section];
        return model.stags.count;
    }
    else
    {
        //如果是关闭的就返回0
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AmortizationLoanCell";//这个identifier跟xib设置的一样
    AmortizationLoanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AmortizationLoanCell" owner:self options:nil]  lastObject];
    }
    AmortizationLoan *model = self.dataArray[indexPath.section];
    NSArray *array = model.stags;
    [cell refreshData:array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AmortizationHeadView *view = [[AmortizationHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.delegate = self;
    view.rightBtn.tag = section;
    AmortizationLoan *model = self.dataArray[section];
    NSString *qi = [self HanziWithNum:[model.stagCount intValue]];
    view.orderNo.text = [NSString stringWithFormat:@"订单编号：%@(%@期付款)",model.no,qi];
    return view;
}

-(void)showAndHiddrenCell:(UIButton *)sender{
    _isOpen[sender.tag] = !_isOpen[sender.tag];
    [self.mTableView reloadData];
    
    
}

// 数字转成汉字
- (NSString *)HanziWithNum:(int)num{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt: num]];
    
    return string;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
