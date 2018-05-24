//
//  AmortizationLoanViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AmortizationLoanViewController.h"
#import "AmortizationLoanCell.h"
@interface AmortizationLoanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation AmortizationLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分期还款";
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"AmortizationLoanCell" bundle:nil] forCellReuseIdentifier:@"AmortizationLoanCell"];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AmortizationLoanCell";//这个identifier跟xib设置的一样
    AmortizationLoanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AmortizationLoanCell" owner:self options:nil]  lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    view.backgroundColor = [UIColor whiteColor];
    UILabel *orderNoLab = [[UILabel alloc]init];
    orderNoLab.text = @"订单编号：122333434(三期付款)";
    [view addSubview:orderNoLab];
    [orderNoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.left.mas_offset(15);
        make.width.mas_offset(200);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    [btn setTitle:@"两期待付" forState:0];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_offset(200);
    }];
    
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
