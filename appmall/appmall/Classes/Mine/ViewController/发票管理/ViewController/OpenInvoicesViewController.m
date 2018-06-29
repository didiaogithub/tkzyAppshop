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
#import "XWAlterVeiw.h"
@interface OpenInvoicesViewController ()<UITableViewDelegate,UITableViewDataSource,XYTableViewDelegate,XWAlterVeiwDelegate>
{
    NSArray *nameArray;
}
/**  发票邮箱*/
@property (nonatomic, strong)IBOutlet UITextField *ffyxTextField;
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
    
    [self.ffyxTextField becomeFirstResponder];
    self.ffyxTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.orderNoLab.text = [NSString stringWithFormat:@"订单号:%@",self.orderno];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"OpenInvoicesCell" bundle:nil] forCellReuseIdentifier:@"OpenInvoicesCell"];
    
    self.mTableView.tableFooterView = [UIView new];
    
    [self setUpRightItem];
    
    [self getData];
}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"发票无"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无我的发票哦";
    return str;
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
        if ([self.model.invoiceheadtype isEqualToString:@"2"]) { // 企业单位
             nameArray = @[@"抬头类型",@"发票抬头",@"税号",@"开户行",@"账号",@"地址",@"电话",@"产品清单",@"发票金额"];
        }else{ // 个人/非企业单位
             nameArray = @[@"抬头类型",@"发票抬头",@"产品清单",@"发票金额"];
        
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == nameArray.count - 2) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 0;
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
        self.model.content = [self.model.content stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        CGSize size = [self.model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        return AdaptedHeight(size.height + 30);
        
    }else{
        return 60;
    }
    return 0;
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
        cell.nameLab.text = nameArray[indexPath.row];
        cell.contentLab.hidden = NO;
         self.model.content = [self.model.content stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        cell.contentLab.text = self.model.content;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 0;
        
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle};
        CGSize size = [cell.contentLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        [cell.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(AdaptedHeight(size.height + 30));
        }];
       
        
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
            cell.contentLab.text = self.model.cardno;
        }else if (indexPath.row == 5){
            cell.contentLab.text = self.model.address;
        }else if (indexPath.row == 6){
            cell.contentLab.text = self.model.mobile;
        }else if (indexPath.row == 7){
            cell.contentLab.text = self.model.content;
        }else if (indexPath.row == 8){
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

// 验证邮箱是否是合法邮箱
- (BOOL )validationEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:email]){
        return YES;
    }else{
        [self showNoticeView:@"请输入合法的邮箱"];
        return NO;
    }
    return NO;
}

- (void)submitData{
    
    if (IsNilOrNull(self.ffyxTextField.text)) {
        [self showNoticeView:@"请输入发票邮箱"];
        return;
    }else{
        
        if ([self validationEmail:self.ffyxTextField.text] == YES) {
            
        }else{
            return;
        }
        
        
    }
    
    
    XWAlterVeiw *alertView = [[XWAlterVeiw alloc] init];
    alertView.delegate = self;
    alertView.titleLable.text = @"提交后不可修改，确认提交吗？";
    [alertView show];
    
    
    
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
        
        if ([self.model.invoiceheadtype isEqualToString:@"2"]) { // 企业单位
            nameArray = @[@"抬头类型",@"发票抬头",@"税号",@"开户行",@"账号",@"地址",@"电话",@"产品清单",@"发票金额"];
        }else{ // 个人/非企业单位
            nameArray = @[@"抬头类型",@"发票抬头",@"产品清单",@"发票金额"];
            
        }
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

- (void)subuttonClicked{
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

@end
