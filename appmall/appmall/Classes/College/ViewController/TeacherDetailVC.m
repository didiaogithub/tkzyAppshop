//
//  TeacherDetailVC.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "TeacherDetailVC.h"
#import "TeacherInfoViewCell.h"
#import "TeacherClassListViewCell.h"
#import "WebDetailViewController.h"
#import "ClassItemViewCell.h"

#define KTeacherInfoViewCell @"TeacherInfoViewCell"
#define KClassItemViewCell @"ClassItemViewCell"
#import "TeacherListItemModel.h"
#import "ClassListModel.h"

@interface TeacherDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *tabDisBottom;
    __weak IBOutlet NSLayoutConstraint *tabDisTop;
}
@property (weak, nonatomic) IBOutlet UITableView *tabClassListView;
@property(nonatomic,strong)TeacherListItemModel *teacherModel;
@property(nonatomic,strong)NSMutableArray<ClassListModel *> *classList; 

@end

@implementation TeacherDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavtion];
    [self setTableView];
    
    [UITableView refreshHelperWithScrollView:self.tabClassListView target:self loadNewData:@selector(loadData) loadMoreData:nil isBeginRefresh:NO];
    [self loadData];
}

-(void)loadData{
    
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setValuesForKeysWithDictionary:@{@"teacherId":self.teacherId}];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetTeacherById];
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        [self.tabClassListView tableViewEndRefreshCurPageCount: 0];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        
        if (dic != nil) {
            for (NSDictionary *itemDic in dic[@"data"][@"courseList"]) {
                ClassListModel *item = [[ClassListModel alloc]initWith:itemDic];
                [self.classList addObject:item];
            }
            _teacherModel =[ [TeacherListItemModel alloc]initWith:dic[@"data"][@"info"]];
            [self.tabClassListView reloadData];
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

- (void)setNavtion {
    self.navigationController.navigationBar.translucent=YES;
    UIColor *color=[UIColor clearColor];
    CGRect rect =CGRectMake(0,0,self.view.frame.size.width,64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:(UIBarMetricsDefault)];
    self.navigationController.navigationBar.clipsToBounds=YES;
}

-(void)setTableView{
    self.tabClassListView.delegate = self;
    self.tabClassListView.dataSource = self;
    [self.tabClassListView registerNib:[UINib nibWithNibName:KTeacherInfoViewCell bundle:nil] forCellReuseIdentifier:KTeacherInfoViewCell];
    tabDisTop.constant = 0;
    tabDisBottom .constant = BOTTOM_BAR_HEIGHT ;
    [self.tabClassListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];
    [self.tabClassListView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma  mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.classList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        TeacherInfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KTeacherInfoViewCell];
        [cell refreshData:_teacherModel];
        return cell;
    }else{
        ClassItemViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KClassItemViewCell];
        [cell refreshDataWIthModel:self.classList[indexPath.row]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 280;
    }else{
        return 140;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 35;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }else{
        UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 35)];
        header.text = @"课程专题";
        header.backgroundColor = [UIColor whiteColor];
        header.textAlignment = NSTextAlignmentCenter;
        header.textColor = RGBCOLOR(48, 48, 48);
        header.font = [UIFont systemFontOfSize:15];
        return header;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebDetailViewController *webDetailVC = [[WebDetailViewController alloc]init];
    webDetailVC.detailUrl = [NSString stringWithFormat:@"%@%@",CollectionDetail,self.classList[indexPath.row].courseId];
    [self.navigationController pushViewController:webDetailVC animated:YES];
}
@end
