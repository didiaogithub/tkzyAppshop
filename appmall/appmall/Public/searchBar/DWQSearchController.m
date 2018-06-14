
//
//  Created by 杜文全 on 16/8/14.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//
/******* 屏幕尺寸 *******/
#define DWQMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define DWQMainScreenHeight [UIScreen mainScreen].bounds.size.height
#define DWQMainScreenBounds [UIScreen mainScreen].bounds
#import "DWQSearchController.h"
#import "DWQSearchBar.h"
#import "RootNavigationController.h"
#import "DWQTagView.h"
#import "XWAlterVeiw.h"
#import "GoodsDetailViewController.h"
#import "HistorySearchCell.h"
#import "ClassListModel.h"
#import "HotSerachCell.h"
#import "ClassItemViewCell.h"
#import "WebDetailViewController.h"
#import "SCCategoryTableCell.h"
#import "SCCategoryGoodsModel.h"
#define KSCCategoryTableCell @"SCCategoryTableCell"
static NSString *const HotCellID = @"HotCellID";
static NSString *const HistoryCellID = @"HistoryCellID";

@interface DWQSearchController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DWQTagViewDelegate,CatogoryAddToShoppingCarDelete>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) DWQSearchBar *searchBar;
@property(nonatomic,strong)UITableView *resultTableView;
/** 历史搜索数组 */
@property (nonatomic, strong) NSMutableArray *historyArr;
/** 热门搜索数组 */
@property (nonatomic, strong) NSMutableArray *HotArr;
/** 得到热门搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagViewHeight;
@property (nonatomic ,assign) CGFloat hisViewHeight;
@property(nonatomic,strong)NSMutableArray <ClassListModel *> *classArray;
@property(nonatomic,strong)NSMutableArray <SCCategoryGoodsModel *> *goodsArray;
@end

@implementation DWQSearchController
-(instancetype)init
{
    if (self = [super init]) {
        self.historyArr = [NSMutableArray array];
        self.HotArr = [NSMutableArray array];
        self.resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, KscreenWidth, KscreenHeight)];
        [UITableView refreshHelperWithScrollView:self.resultTableView target:self loadNewData:nil loadMoreData:nil isBeginRefresh:NO];
        self.resultTableView.delegate = self;
        self.resultTableView.dataSource = self;
        self.resultTableView.hidden = YES;
         [self.resultTableView registerNib:[UINib nibWithNibName:@"ClassItemViewCell" bundle:nil] forCellReuseIdentifier:@"ClassItemViewCell"];
           [self.resultTableView registerNib:[UINib nibWithNibName:KSCCategoryTableCell bundle:nil] forCellReuseIdentifier:KSCCategoryTableCell];

        [self.view addSubview:self.resultTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.classArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

  
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(245, 245, 245);
}
-(void)initData{

    /**
     *  造热门搜索的假数据
     */
    if (self.seachVCIndex == 0) {
        self.historyArr = [NSMutableArray arrayWithArray:[KUserdefaults objectForKey:@"historyArrHome"]] ;
    }else{
        self.historyArr = [NSMutableArray arrayWithArray:[KUserdefaults objectForKey:@"historyArr"]] ;
    }
    

    [self loadDataHot];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self initData];
}

-(void)loadDataResutl{
    [self.searchBar resignFirstResponder];
    self.resultTableView.hidden = NO;
    self.tableview.hidden = YES;
    
    [self.view bringSubviewToFront:self.resultTableView];
    [self.view sendSubviewToBack:self.tableview];
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    //请求数据
    NSString *homeInfoUrl ;
    if (self.seachVCIndex == 0) {
        if (self.searchBar.text .length != 0) {
            
            [pramaDic setObject:self.searchBar.text forKey:@"name"];
        }
        homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,Goods_search];
    }else{
        [pramaDic setObject:self.searchBar.text forKey:@"keyword"];
        homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetCourseListByKey];
    }
 
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
            [self createUI];
            return;
        }
        if (self.seachVCIndex == 0) {
            
            
            NSArray *list = dic[@"data"][@"goodsList"];
            [self.goodsArray removeAllObjects];
            
            if (list.count != 0) {
                for (NSDictionary *itemDic in dic[@"data"][@"goodsList"]) {
                    SCCategoryGoodsModel *model = [[SCCategoryGoodsModel alloc]initWith:itemDic];
                    [self.goodsArray addObject:model];
                }
            }else{
                [self.loadingView showNoticeView:@"没有该商品"];
            }
            
        }else{
            NSArray *list = dic[@"data"][@"courseList"];
            [self.classArray removeAllObjects];
            
            if (list.count != 0) {
                for (NSDictionary *itemDic in dic[@"data"][@"courseList"]) {
                    ClassListModel *model = [[ClassListModel alloc]initWith:itemDic];
                    [self.classArray addObject:model];
                }
            }else{
                [self.loadingView showNoticeView:@"没有该类课程"];
            }
        }
      
        
        [self.resultTableView reloadData];
        [self createUI];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)loadDataHot{
    
    NSMutableDictionary *pramaDic =[NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    //请求数据
    NSString *homeInfoUrl;
    if (self.seachVCIndex == 0) {
         homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GoodsgetHotSearchList];
    }else{
            homeInfoUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,GetHotSearchList];
    }
    
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [HttpTool getWithUrl:homeInfoUrl params:pramaDic success:^(id json) {
        [self.loadingView stopAnimation];
        
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            [self.loadingView showNoticeView:dic[@"message"]];
              [self createUI];
            return;
        }
        
        if (self.seachVCIndex == 0) {
            if (dic != nil) {
                self.HotArr = dic[@"data"][@"hotSearchList"];
            }else{
                self.HotArr = @[];
            }
        }else{
            if (dic != nil) {
                self.HotArr = dic[@"data"][@"hotSearchList"];
            }else{
                self.HotArr = @[];
            }
        }
       
          [self createUI];
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
        if (error.code == -1009) {
            [self.loadingView showNoticeView:NetWorkNotReachable];
        }else{
            [self.loadingView showNoticeView:NetWorkTimeout];
        }
        
    }];
}

-(void)createUI{

    self.view.backgroundColor=[UIColor whiteColor];
    DWQSearchBar *bar = [[DWQSearchBar alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth-100, 30)];
    bar.layer.cornerRadius=4;
    bar.layer.masksToBounds=YES;
    bar.placeholder=@"输入你想要找的产品名称";
    _searchBar = bar;
    
    bar.delegate = self;
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setTitle:@"取消" forState:0];
    [rightBtn setTitleColor:[UIColor grayColor] forState:0];
    [rightBtn addTarget:self  action:@selector(actionCancell) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.titleView = bar;

    
    [self.view addSubview:self.tableview];
}

-(void)actionCancell{
    [self .navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.resultTableView) {
        if (self.seachVCIndex == 0) {
            return self.goodsArray.count;
        }else{
            
            return self.classArray.count;
        }
    }else{
        if (self.historyArr.count == 0) {
            return 1;
        }
        else
        {
            return 1;
        }
    }

}
/** section的数量 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.resultTableView) {
        return 1;
    }else{
        if (self.historyArr.count == 0) {
            return 1;
        }
        else
        {
            return 2;
        }
    }
  
}
/** 使第一个cell（热门搜索的cell不可编辑） */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView  == self.resultTableView) {
         return UITableViewCellEditingStyleNone;
    }else{
        if (indexPath.section == 0) {
            return UITableViewCellEditingStyleNone;
        }
        else
        {
            return UITableViewCellEditingStyleDelete;
        }
    }
}
/** CELL */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    if (tableView == self.resultTableView) {
        if (self.seachVCIndex == 0) {
            SCCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:KSCCategoryTableCell];
            [cell refreshCellWithModel:[self.goodsArray objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            
            return cell;
        }else{
            ClassItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassItemViewCell"];
            [cell refreshDataWIthModel:[self.classArray objectAtIndex:indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
  
    }else{
        if (self.historyArr.count == 0) {
            HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
            
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            hotCell.userInteractionEnabled = YES;
            hotCell.hotSearchArr = self.HotArr;
            hotCell.dwqTagV.delegate = self;
            /** 将通过数组计算出的tagV的高度存储 */
            self.tagViewHeight = hotCell.dwqTagV.frame.size.height ;
            return hotCell;
        }
        else
        {
            if (indexPath.section == 0) {
                HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
                hotCell.dwqTagV.delegate = self;
                hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
                hotCell.userInteractionEnabled = YES;
                hotCell.hotSearchArr = self.historyArr;
                /** 将通过数组计算出的tagV的高度存储 */
                self.hisViewHeight = hotCell.dwqTagV.frame.size.height;
                return hotCell;
            }
            else
            {
                HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:HotCellID forIndexPath:indexPath];
                
                hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
                hotCell.userInteractionEnabled = YES;
                hotCell.hotSearchArr = self.HotArr;
                hotCell.dwqTagV.delegate = self;
                /** 将通过数组计算出的tagV的高度存储 */
                self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
                return hotCell;
            }
        }
    }
    return cell;

}
/** HeaderView */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.resultTableView) {
        return [UIView new];
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
        headView.backgroundColor = [UIColor colorWithWhite:0.922 alpha:1.000];
        for (UILabel *lab in headView.subviews) {
            [lab removeFromSuperview];
        }
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 10, 45)];
        
        
        titleLab.textColor = [UIColor colorWithWhite:0.229 alpha:1.000];
        titleLab.font = [UIFont systemFontOfSize:14];
        [headView addSubview:titleLab];
        if (self.historyArr.count == 0) {
            
            titleLab.text = @"热门搜索";
            UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,1)];
            backLab.backgroundColor = RGBCOLOR(220, 220, 220);
            [headView addSubview:backLab];
        }
        else
        {
            if (section == 0) {
                
                UIButton *deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(KscreenWidth - 55, 0, 44, 44)];
                [deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:0];
                [headView addSubview:deleteBtn];
                UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,1)];
                backLab.backgroundColor = RGBCOLOR(220, 220, 220);
                [headView addSubview:backLab];
                [deleteBtn addTarget:self  action:@selector(removeAllHistoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
                titleLab.text = @"历史记录";
            }
            else
            {
                titleLab.text = @"热门搜索";
                UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,10)];
                backLab.backgroundColor = RGBCOLOR(220, 220, 220);
                [headView addSubview:backLab];
                
            }
        }
        
        headView.backgroundColor = [UIColor whiteColor];
        return headView;
    }

}
/** FooterView */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
        return view;
    
}
/** 头部的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.resultTableView) {
        return 0.1;
    }else{
         return 45;
    }
   
}
/** cell的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.resultTableView) {
        return 120;
    }else{
        if (self.historyArr.count == 0) {
            
            return self.tagViewHeight + 40;
        }
        else
        {
            if (indexPath.section == 0) {
                return self.hisViewHeight + 40 ;
            }
            else
            {
                return self.tagViewHeight + 20;
            }
        }
    }

}
/** FooterView的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView == self.resultTableView) {
        return 0.1;
    }else{
        if (self.historyArr.count == 0) {
            return 0.1;
        }
        else
        {
            if (section == 0) {
                return 0.1;
            }
            else
            {
                return 46;
            }
        }
    }

}
#pragma mark -- 实现点击热门搜索tag  Delegate
-(void)DWQTagView:(UIView *)dwq fetchWordToTextFiled:(NSString *)KeyWord
{
    NSLog(@"点击了%@",KeyWord);
       [self.searchBar becomeFirstResponder];
    self.searchBar.text=KeyWord;
    [self.view bringSubviewToFront:self.tableview];
    self.tableview.hidden = NO;
    self.resultTableView.hidden = YES;
    
}

#pragma mark -- 删除单个搜索历史
-(void)removeSingleTagClick:(UIButton *)removeBtn
{
    [self.historyArr removeObjectAtIndex:removeBtn.tag - 250];
    
    [self.tableview reloadData];
}
#pragma mark -- 删除所有的历史记录
-(void)removeAllHistoryBtnClick
{
    [self.historyArr removeAllObjects];
    if (self.seachVCIndex == 0) {
        [KUserdefaults setObject:@[] forKey:@"historyArrHome"];
    }else{
        [KUserdefaults setObject:@[] forKey:@"historyArr"];
    }
    [self.tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 懒加载
-(UITableView *)tableview
{
    if (!_tableview) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[HotSerachCell class] forCellReuseIdentifier:HotCellID];
        [_tableview registerNib:[UINib nibWithNibName:@"HistorySearchCell" bundle:nil] forCellReuseIdentifier:HistoryCellID];
        _tableview.backgroundColor = [UIColor colorWithWhite:0.934 alpha:1.000];
    }
    return _tableview;
}
//textfield的代理方法：自行写逻辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSMutableArray *hisMarray = [NSMutableArray arrayWithArray:self.historyArr];
    [hisMarray addObject:textField.text];
    self.historyArr = hisMarray;
    if (self.seachVCIndex == 0) {
        [KUserdefaults setObject:hisMarray forKey:@"historyArrHome"];
    }else{
        [KUserdefaults setObject:hisMarray forKey:@"historyArr"];
    }
    
//    [self createUI];
    [self loadDataResutl];
  
       return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;{
    
    
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.seachVCIndex == 0) {
        if (self.goodsArray.count <= indexPath.row) {
            return;
        }
        GoodsDetailViewController *detailVC = [[GoodsDetailViewController alloc] init];
        detailVC.goodsM = self.goodsArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        if (self.classArray.count <= indexPath.row) {
            return;
        }
        WebDetailViewController *detailVC = [[WebDetailViewController alloc]init];
        detailVC.detailUrl = [NSString stringWithFormat:@"%@%@",CollectionDetail,self.classArray[indexPath.row].courseId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(void)goWelcom{
    SCLoginViewController *welcome =[[SCLoginViewController alloc] init];
    RootNavigationController *welcomeNav = [[RootNavigationController alloc] initWithRootViewController:welcome];
    
    [self presentViewController:welcomeNav animated:YES completion:nil];
}
-(void)addGoodsToShoppingCar:(SCCategoryGoodsModel *)cateM {
    
    if ([[KUserdefaults objectForKey:KloginStatus] boolValue] == NO) {
        [self goWelcom];
        return;
    }

        NSLog(@"加入购物车");
        
        NSMutableDictionary *pramaDic = [[NSMutableDictionary alloc]initWithDictionary:[HttpTool getCommonPara]];
        NSString* itemsStr  = [@[@{@"itemid":cateM.itemid,@"num":@"1"}] mj_JSONString];
        [pramaDic setObject:itemsStr forKey:@"items"];
        NSString *loveItemUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI, AddToShoppingCarUrl];
        
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimation];
        
        [HttpTool postWithUrl:loveItemUrl params:pramaDic success:^(id json) {
            [self.loadingView stopAnimation];
            NSDictionary *dic = json;
            NSString * status = [dic valueForKey:@"code"];
            if ([status intValue] != 200) {
                [self showNoticeView:[dic valueForKey:@"message"]];
                return ;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@"AddToShoppingCarSuccess" forKey:@"SCChangedShopingCar"];
            [self showNoticeView:@"亲，在购物车等你哦"];
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
