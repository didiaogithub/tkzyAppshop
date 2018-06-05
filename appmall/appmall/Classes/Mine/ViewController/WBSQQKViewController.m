//
//  WBSQQKViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WBSQQKViewController.h"
#import "LoanRuleListModel.h"
#import "WBSelectFeQiItemViewCell.h"
#import "WBSQQKInfoViewCell.h"

#define applyForMoneyApi @"Rule/applyForMoney"
#define getLoanRuleListApi @"Rule/getLoanRuleList"
@interface WBSQQKViewController ()<UITableViewDelegate,UITableViewDataSource,WBSelectFeQiItemViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
/**  dataArray*/
@property (nonatomic, strong) NSMutableArray <LoanRuleListModel *>*dataArray;

@property (weak, nonatomic)  UITextField *sqPerson;
@property (weak, nonatomic)  UITextView *sqRerson;
@property (weak, nonatomic)  UITextField *sqPhone;
/**  loadid*/
@property (nonatomic, strong) NSString  *loadid;
@property (nonatomic, strong) UIButton *lastSelectedButton;

@end

@implementation WBSQQKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请欠款";
    self.view.backgroundColor = [UIColor tt_borderColor];
    self.dataArray = [NSMutableArray array];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = [UIColor tt_borderColor];
    [self getLoanRuleList];
     [self.mTableView registerNib:[UINib nibWithNibName:@"WBSelectFeQiItemViewCell" bundle:nil] forCellReuseIdentifier:@"WBSelectFeQiItemViewCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"WBSQQKInfoViewCell" bundle:nil] forCellReuseIdentifier:@"WBSQQKInfoViewCell"];
    
    self.mTableView.tableFooterView = [UIView new];
}


- (void)getLoanRuleList{
    NSMutableDictionary *paradic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    if (IsNilOrNull(self.orderid)) {
        return;
    }
    [paradic setObject:self.orderid forKey:@"orderid"];
    NSString *requsetUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getLoanRuleListApi];
    [HttpTool getWithUrl:requsetUrl params:paradic success:^(id json) {
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        NSArray *list = dic[@"data"][@"list"];
        
        for (NSDictionary *dic in list) {
            LoanRuleListModel *model = [[LoanRuleListModel alloc]initWith:dic];
            [self.dataArray addObject:model];
          
        }
        [self.dataArray firstObject].isSelect = YES;
          [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"WBSQQKInfoViewCell";//这个identifier跟xib设置的一样
        WBSQQKInfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"WBSQQKInfoViewCell" owner:self options:nil]  lastObject];
        }
        
        cell.sqRerson.layer.borderColor = [UIColor tt_lineBgColor].CGColor;
        cell.sqRerson.layer.borderWidth = 1;
        cell.sqRerson.layer.masksToBounds = YES;
        cell.sqRerson.layer.cornerRadius = 3;
        self.sqPerson = cell.sqPerson;
        self.sqPhone = cell.sqPhone;
        self.sqRerson = cell.sqRerson;
        return cell;
    }else{
        static NSString *identifier = @"WBSelectFeQiItemViewCell";//这个identifier跟xib设置的一样
        WBSelectFeQiItemViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"WBSelectFeQiItemViewCel" owner:self options:nil]  lastObject];
        }
        
//        if (indexPath.row == 0) {
//          cell.selectBtn.selected = YES;
//        }
        cell.delegate = self;
        cell.selectBtn.selected =self.dataArray[indexPath.row].isSelect;
        [cell refreshData:self.dataArray[indexPath.row]];
        return cell;
        
    }

    return nil;
}

- (void)tableCellButtonDidSelected:(LoanRuleListModel *)model{

    for (LoanRuleListModel *itemModel in self.dataArray) {
        itemModel.isSelect = NO;
    }
    model.isSelect = YES;
    self.loadid = model.loanid;
    [self.mTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 300;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        LoanRuleListModel *model =  self.dataArray[indexPath.row];
        
        self.loadid = model.loanid;
    }
    
}
- (IBAction)sendDataAction:(id)sender {
    
    if (IsNilOrNull(self.sqPerson.text)) {
        [self showNoticeView:@"请输入申请人"];
    }
    if (IsNilOrNull(self.sqPhone.text)) {
        [self showNoticeView:@"请输入联系方式"];
    }
    if (IsNilOrNull(self.sqPerson.text)) {
        [self showNoticeView:@"请输入申请理由"];
    }
    
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [paraDic setObject:self.orderid forKey:@"orderid"];
    [paraDic setObject:self.sqPerson.text forKey:@"applyname"];
    [paraDic setObject:self.sqPhone.text forKey:@"phone"];
    [paraDic setObject:self.sqRerson.text forKey:@"applyreason"];
    [paraDic setObject:self.loadid forKey:@"loanid"];
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,applyForMoneyApi];
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    [HttpTool postWithUrl:requestUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
        if (![code isEqualToString:@"200"]) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        [self showNoticeView:@"提交成功"];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
