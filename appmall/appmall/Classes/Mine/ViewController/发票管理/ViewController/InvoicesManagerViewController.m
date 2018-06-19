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
    
    self.headView = [[InvoicesManagerHeadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, AdaptedHeight(127))];
    [self.view addSubview:self.headView];

    [self segmentStyle5];

    [self setRightButton:@"开票信息"];
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
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64 + AdaptedHeight(127) + 10, SCREEN_WIDTH , 43) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.headColor = [UIColor whiteColor];
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 16;
    _segHead.lineScale = .3;
    _segHead.lineColor = [UIColor tt_redMoneyColor];
    _segHead.lineHeight = 1;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = [UIColor clearColor];
    _segHead.selectColor = [UIColor tt_redMoneyColor];
    _segHead.deSelectColor = [UIColor blackColor];
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 64 + AdaptedHeight(127) + 60, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - AdaptedHeight(127) - 60) vcOrViews:[self vcArr:list.count]];
    
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
