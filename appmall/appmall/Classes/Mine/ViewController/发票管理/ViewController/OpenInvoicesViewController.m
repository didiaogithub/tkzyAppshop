//
//  OpenInvoicesViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "OpenInvoicesViewController.h"
#import "OpenInvoicesCell.h"
#import "MyInvoicesViewController.h"
@interface OpenInvoicesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *nameArray;
}
- (IBAction)showinvoicesDetail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation OpenInvoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开发票";
    
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"OpenInvoicesCell" bundle:nil] forCellReuseIdentifier:@"OpenInvoicesCell"];
    nameArray = @[@"抬头类型",@"发票抬头",@"税号",@"发票内容",@"收票邮箱",@"发票金额"];
    self.mTableView.tableFooterView = [UIView new];
    
    [self setUpRightItem];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OpenInvoicesCell";//这个identifier跟xib设置的一样
    OpenInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell= [[[NSBundle  mainBundle]
                loadNibNamed:@"OpenInvoicesCell" owner:self options:nil]  lastObject];
    }
    cell.nameLab.text = nameArray[indexPath.row];
    return cell;
}

#pragma mark - 提交
-(void)setUpRightItem {
    
    if (@available(iOS 11.0, *)) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitData)];
        right.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = right;
    }else{
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提交 " style:UIBarButtonItemStylePlain target:self action:@selector(submitData)];
        right.tintColor = [UIColor redColor];
        self.navigationItem.rightBarButtonItem = right;
    }
}


- (void)submitData{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArray.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)showinvoicesDetail:(UIButton *)sender {
    MyInvoicesViewController *myinvoices = [[MyInvoicesViewController alloc]init];
    [self.navigationController pushViewController:myinvoices animated:YES];
    
}
@end
