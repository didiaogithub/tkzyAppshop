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
/**  发票邮箱*/
@property (nonatomic, strong) UITextField *ffyxTextField;
- (IBAction)showinvoicesDetail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;

@end

@implementation OpenInvoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开发票";
    self.orderNoLab.text = [NSString stringWithFormat:@"订单号:%@",self.orderno];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"OpenInvoicesCell" bundle:nil] forCellReuseIdentifier:@"OpenInvoicesCell"];
    nameArray = @[@"抬头类型",@"发票抬头",@"税号",@"开户行",@"账号",@"地址",@"电话",@"发票内容",@"收票邮箱",@"发票金额"];
    self.mTableView.tableFooterView = [UIView new];
    
    [self setUpRightItem];
    
    [self getData];
}

- (void)getData{
    
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.orderid forKey:@"orderid"];
//    [pramaDic setObject:@"df9e345e28349f5911a413026924f63c" forKey:@"token"];    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getInvoiceByIdApi];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSArray *Arr = dict[@"data"];
     
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenInvoicesCell *cell;
    if (indexPath.row == nameArray.count - 2) {
        static NSString *identifier = @"OpenInvoicesCell";//这个identifier跟xib设置的一样
         cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"OpenInvoicesCell" owner:self options:nil]  lastObject];
        }
        
        cell.nameLab.text = nameArray[indexPath.row];
        cell.contentLab.hidden = YES;
        self.ffyxTextField = [[UITextField  alloc]init];
        [cell.contentView addSubview:self.ffyxTextField];
        [self.ffyxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.bottom.mas_equalTo(cell);
        }];
        self.ffyxTextField.placeholder = @"用于接受电子发票";
        self.ffyxTextField.font = [UIFont systemFontOfSize:15];
    }else{
        static NSString *identifier = @"OpenInvoicesCell";//这个identifier跟xib设置的一样
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"OpenInvoicesCell" owner:self options:nil]  lastObject];
        }
        
        cell.nameLab.text = nameArray[indexPath.row];
    }
   
    
    
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
