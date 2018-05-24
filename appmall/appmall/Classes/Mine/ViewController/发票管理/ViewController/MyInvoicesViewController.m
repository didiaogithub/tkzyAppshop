//
//  MyInvoicesViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MyInvoicesViewController.h"
#import "MyInvoicesCell.h"
#import "MyinvoicesCheckingCell.h"
#import "MyInvoicesCheckFailCell.h"
#import "AddInvoicesDataViewController.h"
@interface MyInvoicesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)addinvoicesDataAction:(UIButton *)sender;

@end

@implementation MyInvoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的发票";
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyinvoicesCheckingCell" bundle:nil] forCellReuseIdentifier:@"MyinvoicesCheckingCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCheckFailCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCheckFailCell"];
    self.mTableView.tableFooterView = [UIView new];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tcell;
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"MyInvoicesCell";//这个identifier跟xib设置的一样
        MyInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCell" owner:self options:nil]  lastObject];
        }
        tcell = cell;
    }else if (indexPath.section == 1){
        static NSString *identifier = @"MyinvoicesCheckingCell";//这个identifier跟xib设置的一样
        MyInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyinvoicesCheckingCell" owner:self options:nil]  lastObject];
        }
         tcell = cell;
        
    }else{
        static NSString *identifier = @"MyInvoicesCheckFailCell";//这个identifier跟xib设置的一样
        MyInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCheckFailCell" owner:self options:nil]  lastObject];
        }
        
         tcell = cell;
        
    }
   
    return tcell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    view.backgroundColor = [UIColor tt_lineBgColor];
    UILabel *type = [UILabel new];
    type.frame = CGRectMake(15,20, SCREEN_WIDTH, 20);
    type.font = [UIFont systemFontOfSize:14];
    type.text = @"审核中";
    if (section == 2) {
       type.text = @"审核失败";
        type.textColor = [UIColor redColor];
    }
    
    [view addSubview:type];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor tt_lineBgColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 2) {
        return 136;
    }
    return 83;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
           return 10;
    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addinvoicesDataAction:(UIButton *)sender {
    
    AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}
@end
