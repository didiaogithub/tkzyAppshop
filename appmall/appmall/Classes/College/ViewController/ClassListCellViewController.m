//
//  ClassListCellViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassListCellViewController.h"
#import "WBMenu.h"
#import "ClassItemViewCell.h"
#import "ClassListModel.h"
#define KClassItemViewCell @"ClassItemViewCell"
@interface ClassListCellViewController ()<WBMenuViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classListView;
@property(nonatomic,strong)NSMutableArray <ClassListModel *>*classArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation ClassListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self setTableView];
    
    [self loadData];
    self.classArray = [NSMutableArray arrayWithCapacity:0];
}

-(void)setTableView{
    self.classListView .delegate = self;
    self.classListView.rowHeight = 140;
    self.classListView.dataSource = self;
    [self.classListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{

    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setValuesForKeysWithDictionary:@{@"pageNo":@(_page),@"pageSize":@(KpageSize),@"categoryId":@27}];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetCourseList];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }

        if (dic != nil) {
            for (NSDictionary *itemDic in dic[@"data"][@"courseList"]) {
                ClassListModel *model = [[ClassListModel alloc]initWith:itemDic];
                [self.classArray addObject:model];
            }
            [self .classListView reloadData];
        }else{
            [self.loadingView showNoticeView:@"无更多商品"];
        }

    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)refresh{
    [self showNoticeView:@"刷新数据"];
}

-(BOOL)isRefresh{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.classArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KClassItemViewCell];
    [cell refreshDataWIthModel:[self.classArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
