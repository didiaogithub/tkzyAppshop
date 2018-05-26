//
//  MineInfoViewController.m
//  appmall
//
//  Created by majun on 2018/5/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineInfoCell.h"
#import "AddressTableCell.h"
#import "SexTableCell.h"

@interface MineInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * titleArr;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
- (IBAction)sciconAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation MineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    titleArr= @[@"昵称",@"真实姓名",@"手机号码",@"性别",@"出生日期"];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MineInfoCell" bundle:nil] forCellReuseIdentifier:@"MineInfoCell"];
    self.mTableView.tableFooterView = [UIView new];
    
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 35;
    self.iconImage.layer.borderColor = [UIColor tt_grayBgColor].CGColor;
    self.iconImage.layer.borderWidth = 1;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head] placeholderImage:[UIImage imageNamed:@""]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *tcell;
    if (indexPath.row == 3) {
        static NSString *identifier = @"sexTableCell";//这个identifier跟xib设置的一样
        SexTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"SexTableCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        tcell = cell;
    }else if (indexPath.row == 4){
        static NSString *identifier = @"addressTableCell";//这个identifier跟xib设置的一样
        AddressTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"AddressTableCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        tcell = cell;
    }else{
        static NSString *identifier = @"MineInfoCell";//这个identifier跟xib设置的一样
        MineInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]  loadNibNamed:@"MineInfoCell" owner:self options:nil]  lastObject];
        }
        cell.nameLab.text = titleArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.contentTextField.text = self.model.nickname;
        }else if (indexPath.row == 1){
            cell.contentTextField.text = self.model.realname;
        }else{
            cell.contentTextField.text = self.model.phone;
        }
       
        tcell = cell;
    }
    return tcell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArr.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sciconAction:(UIButton *)sender {
    
    
}
@end
