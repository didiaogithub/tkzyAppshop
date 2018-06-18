//
//  MyInvoicesViewController.m
//  appmall
//
//  Created by majun on 2018/5/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "MyInvoicesViewController.h"
#import "MyInvoicesCell.h"
#import "MyinvoicesCheckingCell.h"
#import "MyInvoicesCheckFailCell.h"
#import "AddInvoicesDataViewController.h"
#import "MyInvoicesModel.h"
#import "XLImageViewer.h"

@interface MyInvoicesViewController ()<UITableViewDataSource,UITableViewDelegate,MyInvoicesCellDelegate,MyInvoicesCheckFailCellDelegate,XYTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)addinvoicesDataAction:(UIButton *)sender;
/**  data*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**  未处理*/
@property (nonatomic, strong) NSMutableArray *wclDataArray;
/**  已处理*/
@property (nonatomic, strong) NSMutableArray <MyInvoicesModel *>*yclDataArray;
/**  已拒绝*/
@property (nonatomic, strong) NSMutableArray *yjjDataArray;

/**  pageNo*/
@property (nonatomic, assign)  NSInteger page;

/**  path*/
@property (nonatomic, strong) NSString *path;

/**  image*/
@property (nonatomic, strong) UIImage *img;

@end

@implementation MyInvoicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的发票";
    self.dataArray = [NSMutableArray array];
    self.yjjDataArray = [NSMutableArray array];
    self.wclDataArray = [NSMutableArray array];
    self.yclDataArray = [NSMutableArray array];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyinvoicesCheckingCell" bundle:nil] forCellReuseIdentifier:@"MyinvoicesCheckingCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"MyInvoicesCheckFailCell" bundle:nil] forCellReuseIdentifier:@"MyInvoicesCheckFailCell"];
    self.mTableView.tableFooterView = [UIView new];
    
    _page = 1;
    [UITableView refreshHelperWithScrollView:self.mTableView target:self  loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    [self setRightButton:@"模板下载" titleColor:[UIColor colorWithHexString:@"#666666"] isTJXHX:YES];
}

- (UIImage *)xy_noDataViewImage{
    
    UIImage *image= [UIImage imageNamed:@"发票无"];
    return image;
}

- (NSString *)xy_noDataViewMessage{
    NSString *str = @"暂无我的发票哦";
    return str;
}


- (void)rightBtnPressed{
    NSLog(@"模板下载");
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    [self getmobanData];
}

- (void)getmobanData{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInvoiceProveApi];
    NSDictionary *paraDic = [HttpTool getCommonPara];
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        [self.loadingView stopAnimation];
        NSDictionary *dic = json;
        if ([dic[@"code"] integerValue] != 200) {
            
            [self.loadingView showNoticeView:dic[@"message"]];
            return;
        }else{
            self.path = dic[@"data"][@"path"];
        
            [[XLImageViewer shareInstanse]showNetImages:@[self.path] index:0 from:self.view];
//            [self toSaveImage:self.path];
        }
    } failure:^(NSError *error) {
        [self.loadingView stopAnimation];
    }];
}



- (void)toSaveImage:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache)
        {
            _img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            _img = [UIImage imageWithData:data];
        }
    }];
   
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(_img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        [self.loadingView stopAnimation];
        // Show error message…
        [self showNoticeView:@"图片保存失败"];
        
    }
    else  // No errors
    {
        [self.loadingView stopAnimation];
        // Show message image successfully saved
        [self showNoticeView:@"图片保存成功"];
    }
}
-(void)loadNewData{
    _page =  1;
    [self getData];
}

-(void)loadMoreData{
    _page ++;
    [self getData];
}

- (void)getData{
    
    
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    NSMutableDictionary *pramaDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [pramaDic setObject:@(_page) forKey:@"pageNo"];
    [pramaDic setObject:@(KpageSize) forKey:@"pageSize"];
//    [pramaDic setObject:@"df9e345e28349f5911a413026924f63c" forKey:@"token"]; // 目前是测试，正式上删除
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@", WebServiceAPI,getMyInvoiceApi];
    [HttpTool getWithUrl:requestUrl params:pramaDic success:^(id json) {
        
        [self.loadingView stopAnimation];
        [self.mTableView.mj_header endRefreshing];
        NSDictionary *dict = json;
        if([dict[@"code"] integerValue] != 200){
            [self.mTableView tableViewEndRefreshCurPageCount:0];
            [self showNoticeView:dict[@"message"]];
        }
        
        if (self.page == 1) {
            [self.wclDataArray removeAllObjects];
            [self.yclDataArray removeAllObjects];
            [self.yjjDataArray removeAllObjects];
        }
        NSArray *Arr = dict[@"data"][@"invoices"];
//        NSArray *Arr = @[];
        [self.mTableView tableViewEndRefreshCurPageCount:Arr.count];
        for (NSDictionary *dic in Arr) {
            MyInvoicesModel *MyInvoicesM = [[MyInvoicesModel alloc] init];
            [MyInvoicesM setValuesForKeysWithDictionary:dic];
            
            if ([MyInvoicesM.disposestatus isEqualToString:@"0"]) {
                [self.wclDataArray addObject:MyInvoicesM];
            }else if ([MyInvoicesM.disposestatus isEqualToString:@"1"]){
                [self.yclDataArray addObject:MyInvoicesM];
                 [self.yclDataArray firstObject].isSelect = YES;
            }else{
                [self.yjjDataArray addObject:MyInvoicesM];
            }
            
        }
        
        [self.mTableView reloadData];
        
    } failure:^(NSError *error) {
//        self.loadingView 
        if (error.code == -1009) {
            [self showNoticeView:NetWorkNotReachable];
        }else{
            [self showNoticeView:NetWorkTimeout];
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tcell;
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"MyInvoicesCell";//这个identifier跟xib设置的一样
        MyInvoicesCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCell" owner:self options:nil]  lastObject];
        }
         cell.delegate = self;
         cell.selectBtn.selected = self.yclDataArray[indexPath.row].isSelect;
        [cell refreshData:self.yclDataArray[indexPath.row]];
       
        
        tcell = cell;
    }else if (indexPath.section == 1){
        static NSString *identifier = @"MyinvoicesCheckingCell";//这个identifier跟xib设置的一样
        MyinvoicesCheckingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyinvoicesCheckingCell" owner:self options:nil]  lastObject];
        }
        [cell refreshData:self.wclDataArray[indexPath.row]];
         tcell = cell;
        
    }else{
        static NSString *identifier = @"MyInvoicesCheckFailCell";//这个identifier跟xib设置的一样
        MyInvoicesCheckFailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell= [[[NSBundle  mainBundle]
                    loadNibNamed:@"MyInvoicesCheckFailCell" owner:self options:nil]  lastObject];
        }
        cell.delegate = self;
        cell.updataFaPDetail.tag = indexPath.row;
        [cell refreshData:self.yjjDataArray[indexPath.row]];
         tcell = cell;
        
        
    }
   
    return tcell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.yclDataArray.count;
    }else if(section == 1){
        return self.wclDataArray.count;
    }else{
        return self.yjjDataArray.count;
    }
    return 0;
}

- (void)tableCellButtonDidSelected:(MyInvoicesModel *)model{
    for (MyInvoicesModel *itemModel in self.yclDataArray) {
        itemModel.isSelect = NO;
    }
    model.isSelect = YES;
    [self.mTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.yjjDataArray.count + self.yclDataArray.count +self.wclDataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    view.backgroundColor = [UIColor tt_lineBgColor];
    UILabel *type = [UILabel new];
    type.frame = CGRectMake(15,10, SCREEN_WIDTH, 14);
    type.font = [UIFont systemFontOfSize:14];
    
    if (section == 2) {
       type.text = @"审核失败";
         [view addSubview:type];
        type.textColor = [UIColor redColor];
    }else if (section == 1){
        type.text = @"审核中";
         [view addSubview:type];
    }else{
        [view removeFromSuperview];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor tt_lineBgColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 136;
    }
    return 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_yjjDataArray.count == 0) {
        if (section == 2 || section == 0) {
            return 0;
        }else{
            return 45;
        }
    }else if (_wclDataArray.count == 0){
        if (section == 1 || section == 0) {
            return 0;
        }else{
            return 45;
        }
    }
    else{
        if (section == 0) {
            return 0;
        }else{
            return 45;
        }
        
   }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
           return 10;
    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addinvoicesDataAction:(UIButton *)sender {
    
    AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        MyInvoicesModel *model = self.yclDataArray[indexPath.row];
        for (MyInvoicesModel *itemModel in self.yclDataArray) {
            itemModel.isSelect = NO;
        }
        model.isSelect = YES;
        [self.mTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(self) weakself = self;
            if (weakself.selectMyInvoicesBlock) {
                weakself.selectMyInvoicesBlock(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}
- (void)setSelectMyInvoicesBlock:(SelectMyInvoicesBlock)selectMyInvoicesBlock{
    _selectMyInvoicesBlock = selectMyInvoicesBlock;
}
//- (BOOL)havData{
//    return NO;
//}

-(void)jumpAddInvoicesDataViewController:(UIButton *)sender{
    AddInvoicesDataViewController *add = [[AddInvoicesDataViewController alloc]init];
    MyInvoicesModel *model = self.yjjDataArray[sender.tag];
    add.tempid = model.invoicetempid;
    add.isUpdateFaPDetail = YES;
    [self.navigationController pushViewController:add animated:YES];
}

@end
