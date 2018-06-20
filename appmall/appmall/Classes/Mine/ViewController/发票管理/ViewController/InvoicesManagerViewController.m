//
//  InvoicesManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerViewController.h"
#import "InvoicesManagerHeadView.h"
#import "InvoicesManagerCell.h"
#import "InvoicesManagerDetailVC.h"
#import "OpenInvoicesViewController.h"
#import "InvoicesManagerModel.h"
#import "InvoicesManCellHeadView.h"
#import "InvoicesManCellFooterView.h"
#import "AddInvoicesDataViewController.h"
#import "MyInvoicesViewController.h"
#import "InvoicesMListViewController.h" // 待开发票、已开发票列表
#import "Ordersheet.h"
#define leftTag 2000
#define rightTag 2001
@interface InvoicesManagerViewController ()<MLMSegmentScrollDelegate>

{
    NSArray *list;
}

/**  headView*/
@property (nonatomic, strong) InvoicesManagerHeadView *headView;

@property (nonatomic,assign) NSInteger currentIndex;





@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation InvoicesManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票管理";
    
    self.headView = [[InvoicesManagerHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH,140)];
    [self.view addSubview:self.headView];

    [self segmentStyle5];
    [self setRightButton:@"开票信息" titleColor:[UIColor colorWithHexString:@"#EF3737"] isTJXHX:YES];
    [self getInvoiceTipData];
}


- (void)getInvoiceTipData{
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",WebServiceAPI,getInvoiceTipApi];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithDictionary:[HttpTool getCommonPara]];
    [HttpTool getWithUrl:requestUrl params:paraDic success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"code"] integerValue] == 200) {
            NSString *info = dict[@"data"][@"info"];
            //处理返回数据
            self.headView.contentLabel.text = info;
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)rightBtnPressed{
     MyInvoicesViewController *my = [[MyInvoicesViewController alloc]init];
    [self.navigationController pushViewController:my animated:YES];
    
}

#pragma mark - 居中下划线
- (void)segmentStyle5 {
    list = @[@"待开发票",@"已开发票"
             ];
    _style = SegmentHeadStyleLine;
    _layout = MLMSegmentLayoutDefault;
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64 + 140 + 10, SCREEN_WIDTH , 43) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.headColor = [UIColor whiteColor];
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 14;
    _segHead.lineScale = .4;
    _segHead.lineColor = [UIColor colorWithHexString:@"#F23030"];
    _segHead.lineHeight = 2;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = [UIColor clearColor];
    _segHead.selectColor = [UIColor colorWithHexString:@"#F23030"];
    _segHead.deSelectColor = [UIColor blackColor];
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 64 +140 + 54, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 140 - 54) vcOrViews:[self vcArr:list.count]];
    
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    _segScroll.segDelegate = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view  addSubview: _segHead];
        [self.view addSubview:_segScroll];
    }];
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        InvoicesMListViewController *Tc;
        if (i == 0) {
            Tc = [InvoicesMListViewController new];
            Tc.selectFirstState = YES;
        }else{
            Tc = [InvoicesMListViewController new];
            Tc.selectFirstState = NO;
        }
        [arr addObject:Tc];
    }
    return arr;
}
///滑动结束
- (void)scrollEndIndex:(NSInteger)index{
   
}
@end
