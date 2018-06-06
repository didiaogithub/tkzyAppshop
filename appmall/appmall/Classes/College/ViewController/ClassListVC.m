//
//  ClassListVC.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassListVC.h"
#import "WBMenu.h"
#import "ClassListCellViewController.h"
#import "ClassCateItem.h"

@interface ClassListVC ()
@property(nonatomic,strong)NSMutableArray <ClassCateItem *> *classCateList;
@property(nonatomic,strong)WBMenu *topMenu;
@end

@implementation ClassListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程列表";
    self.classCateList = [NSMutableArray arrayWithCapacity:0];
    _topMenu = [[WBMenu alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
 
    [self loadData];
    [self.view addSubview:_topMenu];
    // Do any additional setup after loading the view from its nib.
}
//Tkschool/getCourseCatoryList
-(void)loadData{
    NSDictionary *pramaDic= [HttpTool getCommonPara];
    //请求数据
    NSString *homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetCourseCatoryList];

    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];

        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }
        NSString *meid = [NSString stringWithFormat:@"%@", dic[@"meid"]];
        
        if (dic != nil) {
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *itemDic in dic[@"data"][@"categories"]) {
                ClassCateItem *item = [[ClassCateItem alloc]initWith:itemDic];
                [self.classCateList addObject:item];
                [titleArray addObject:item.categoryName];
            }
            
          
            [_topMenu createMenuView:titleArray size:CGSizeMake(70, 30)];
            for (int i = 0; i < titleArray.count ; i ++) {
                ClassListCellViewController * classListVC = [[ClassListCellViewController alloc]init];
                classListVC.classItem = [self.classCateList objectAtIndex:i];
                classListVC.navVC = self;
                [_topMenu addViewController:classListVC atIndex:i];
            }
        }else{
            [self.loadingView showNoticeView:@"无更多课程"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
