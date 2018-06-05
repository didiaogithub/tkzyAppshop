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
#import "OpenInvoiceModel.h"
@interface OpenInvoicesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *nameArray;
}
/**  发票邮箱*/
@property (nonatomic, strong) UITextField *ffyxTextField;
- (IBAction)showinvoicesDetail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
/**  model*/
@property (nonatomic, strong) OpenInvoiceModel *model;
/**  selectmodel*/
@property (nonatomic, strong) MyInvoicesModel *selectModel;

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
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSDictionary *dic = dict[@"data"];
        self.model = [[OpenInvoiceModel alloc]initWithDictionary:dic];
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
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
        
//        if (cell == nil) {
        
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"OpenInvoicesCell" owner:self options:nil]  lastObject];
//        }
        cell.contentLab.hidden = YES;
        self.ffyxTextField = [[UITextField  alloc]init];
        [cell addSubview:self.ffyxTextField];
        NSLog(@"self.ffyxTextField==========");
        [self.ffyxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.top.bottom.mas_equalTo(cell);
        }];
        cell.nameLab.text = nameArray[indexPath.row];
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
        
        if (indexPath.row == 0) {
            if ([self.model.invoiceheadtype isEqualToString:@"2"]) {
                cell.contentLab.text = @"企业单位";
            }else{
                cell.contentLab.text = @"个人/非企业单位";
            }
            
        }else if (indexPath.row == 1){
            cell.contentLab.text = self.model.issuingoffice;
        }else if (indexPath.row == 2){
            cell.contentLab.text = self.model.number;
        }else if (indexPath.row == 3){
            cell.contentLab.text = self.model.bankname;
        }else if (indexPath.row == 4){
            
        }else if (indexPath.row == 5){
            cell.contentLab.text = self.model.cardno;
        }else if (indexPath.row == 6){
            cell.contentLab.text = self.model.address;
        }else if (indexPath.row == 7){
            cell.contentLab.text = self.model.mobile;
        }else if (indexPath.row == 8){
            cell.contentLab.text = self.model.content;
        }else if (indexPath.row == 9){
            cell.contentLab.text = self.model.allprice;
        }
        
        
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
    
    if (IsNilOrNull(self.ffyxTextField.text)) {
        [self showNoticeView:@"请输入发票邮箱"];
        return;
    }
    
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    
    [paraDic setObject:self.orderid forKey:@"orderid"];
    [paraDic setObject:self.model.tempid forKey:@"tempid"];
    [paraDic setObject:self.ffyxTextField.text forKey:@"email"];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,applyInvoiceApi];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:requestUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
         NSDictionary *dict = json;
        if ([dict[@"code"] intValue] != 200) {
            [self.loadingView showNoticeView:dict[@"message"]];
            return ;
        }else{
            [self.loadingView showNoticeView:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
         [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArray.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)showinvoicesDetail:(UIButton *)sender {
    MyInvoicesViewController *myinvoices = [[MyInvoicesViewController alloc]init];
    [myinvoices setSelectMyInvoicesBlock:^(MyInvoicesModel *model) {
        self.selectModel = model;
        NSLog(@"self.selectModel ======= %@",self.selectModel);
        [self getData:self.orderid tempId:self.selectModel.invoicetempid];
    }];
    [self.navigationController pushViewController:myinvoices animated:YES];
    
    
}

- (void)getData:(NSString *)orderid tempId:(NSString *)tempid{

    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.orderid forKey:@"orderid"];
    [pramaDic setObject:tempid forKey:@"tempid"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getInvoiceByIdApi];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self showNoticeView:dict[@"message"]];
        }
        NSDictionary *dic = dict[@"data"];
        self.model = [[OpenInvoiceModel alloc]initWithDictionary:dic];
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
}

@end
