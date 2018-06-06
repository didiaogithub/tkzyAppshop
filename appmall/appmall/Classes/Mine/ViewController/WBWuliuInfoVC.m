

//
//  WBWuliuInfoVC.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "WBWuliuInfoVC.h"
#import "WuliuDetailViewCell.h"
#import "WuliuHeaderViewCell.h"
#define KWuliuHeaderViewCell @"WuliuHeaderViewCell"
#define KWuliuDetailViewCell @"WuliuDetailViewCell"

@interface WBWuliuInfoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UITableView *tabWuliuList;

@property(strong,nonatomic)WuliuModel *wuluModel;
@end

@implementation WBWuliuInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    self.topDis.constant = NaviHeight;
    [self setTableView];
    [self requestOrderDetailData];
}

-(void)setTableView{
    self.tabWuliuList .delegate = self;
    self.tabWuliuList.dataSource = self;
    [self.tabWuliuList registerNib:[UINib nibWithNibName:KWuliuDetailViewCell bundle:nil] forCellReuseIdentifier:KWuliuDetailViewCell];
      [self.tabWuliuList registerNib:[UINib nibWithNibName:KWuliuHeaderViewCell bundle:nil] forCellReuseIdentifier:KWuliuHeaderViewCell];
    [self .tabWuliuList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return   self.wuluModel.infos.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WuliuHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWuliuHeaderViewCell];
        [cell loadData:self.wuluModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WuliuDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWuliuDetailViewCell];
        [cell loadData:self.wuluModel.infos[indexPath.row] atIndex:indexPath.row andInfoCount:self.wuluModel.infos.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  90;
    }else{
        return 85;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 44)];
    headerView.backgroundColor  =[UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 20)];
    titleLab.text = @"物流信息";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor  = RGBCOLOR(100, 100, 100);
    [headerView addSubview:titleLab];
    if (section == 1) {
        return headerView;
    }else{
        return [UIView new];
    }
    
}

-(UIView  *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return  10;
        
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  == 1) {
        return 44;
    }else{
        return 0.1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)requestOrderDetailData{
    NSString *orderDetailUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getOrderTransInfo];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:self.orderid forKey:@"orderid"];
    
    [HttpTool getWithUrl:orderDetailUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] != 200) {
            [self showNoticeView:dict[@"message"]];
            return ;
        }
        self.wuluModel = [[WuliuModel alloc]initWith:dict[@"data"]];
        self.wuluModel.goodNum =[NSString stringWithFormat:@"%ld", self.goodSnum];
        [self.tabWuliuList reloadData];
        
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

@implementation WuliuModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"infos"]) {
        self.infos = value;
        return;
    }
    [super setValue:value   forKey:key];
}
@end

