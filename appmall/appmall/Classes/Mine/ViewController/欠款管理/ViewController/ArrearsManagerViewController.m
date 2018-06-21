//
//  ArrearsManagerViewController.m
//  appmall
//
//  Created by majun on 2018/4/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsManagerViewController.h"
#import "ArrearsMListViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"
#import "ZJSegmentStyle.h"
@interface ArrearsManagerViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate>
{
    NSMutableArray *list;
}
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) NSMutableArray *orderDataArr;
@property (nonatomic, strong) NSMutableArray *statusBtnArr;
//@property (nonatomic, assign) MLMSegmentHeadStyle style;
//@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
//@property (nonatomic, strong) MLMSegmentHead *segHead;
//@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;

@end

@implementation ArrearsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欠款管理";
//    _statusArr = @[@"0", @"1", @"2", @"4",@"5"];
//    [self segmentStyle5];
    list = [NSMutableArray arrayWithArray:@[@"申请中", @"已拒绝", @"待还款", @"已还款",@"担保"]];
     [self initComponents];

}

-(void)initComponents{
    /**设置title样式*/
    _style = [[ZJSegmentStyle alloc] init];
    _style.normalTitleColor = TitleColor;
    _style.selectedTitleColor = [UIColor tt_redMoneyColor];
    _style.scrollLineColor = [UIColor tt_redMoneyColor];
    _style.scrollLineHeight = 2;
    _style.segmentHeight = 43;
    
    //显示滚动条
    _style.showLine = YES;
    _style.titleFont = MAIN_TITLE_FONT;
    _style.autoAdjustTitlesWidth = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 65+NaviAddHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 65-NaviAddHeight-BOTTOM_BAR_HEIGHT) segmentStyle:_style titles:list parentViewController:self delegate:self];
    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];
    
    if (self.selectedIndex != nil) {
       [_scrollPageView setSelectedIndex:self.selectedIndex animated:YES];
    }else{
        [_scrollPageView setSelectedIndex:0 animated:YES];
    }
    
    
    [self.view addSubview:_scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return list.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    ArrearsMListViewController<ZJScrollPageViewChildVcDelegate> *childVc =(ArrearsMListViewController *) reuseViewController;
    
    
    if (!childVc) {
        childVc = (ArrearsMListViewController<ZJScrollPageViewChildVcDelegate> *)[[ArrearsMListViewController alloc] init];
    }
    switch (index) {
        case 0:
            childVc = [ArrearsMListViewController new];
            childVc.isMyspon = NO;
            childVc.statusString = @"0";
            break;
        case 1:
            childVc = [ArrearsMListViewController new];
            childVc.isMyspon = NO;
            childVc.statusString = @"1";
            break;
        case 2:
            childVc = [ArrearsMListViewController new];
            childVc.isMyspon = NO;
            childVc.statusString = @"2";
            break;
        case 3:
            childVc = [ArrearsMListViewController new];
            childVc.isMyspon = NO;
            childVc.statusString = @"4";
            break;
        case 4:
            childVc = [ArrearsMListViewController new];
            childVc.isMyspon = YES;
            childVc.statusString = @"5";
            break;
        default:
            break;
    }
    
    return childVc;
}

#pragma mark - 居中下划线
//- (void)segmentStyle5 {
//
//    _style = SegmentHeadStyleLine;
//    _layout = MLMSegmentLayoutDefault;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH , 43) titles:list headStyle:_style layoutStyle:_layout];
//    _segHead.headColor = [UIColor whiteColor];
//    _segHead.fontScale = 1.0;
//    _segHead.fontSize = 16;
//    _segHead.lineScale = .5;
//    _segHead.lineColor = [UIColor tt_redMoneyColor];
//    _segHead.lineHeight = 2;
//    _segHead.equalSize = YES;
//    _segHead.bottomLineHeight = 1;
//    _segHead.bottomLineColor = [UIColor clearColor];
//    _segHead.selectColor = [UIColor tt_redMoneyColor];
//    _segHead.deSelectColor = [UIColor blackColor];
//    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 64 + 43, SCREEN_WIDTH , SCREEN_HEIGHT - 64 - 43) vcOrViews:[self vcArr:list.count]];
//
//    _segScroll.loadAll = NO;
//    _segScroll.showIndex = 0;
//    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
//        [self.view addSubview:_segScroll];
//        [self.view  addSubview: _segHead];
//    }];
//}

//- (NSArray *)vcArr:(NSInteger)count {
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSInteger i = 0; i < count; i ++) {
//        ArrearsMListViewController *Tc;
//
//        switch (i) {
//            case 0:
//                Tc = [ArrearsMListViewController new];
//                Tc.isMyspon = NO;
//                Tc.statusString = @"0";
//                break;
//            case 1:
//                Tc = [ArrearsMListViewController new];
//                Tc.isMyspon = NO;
//                Tc.statusString = @"1";
//                break;
//            case 2:
//                Tc = [ArrearsMListViewController new];
//                Tc.isMyspon = NO;
//                Tc.statusString = @"2";
//                break;
//            case 3:
//                Tc = [ArrearsMListViewController new];
//                Tc.isMyspon = NO;
//                Tc.statusString = @"4";
//                break;
//            case 4:
//                Tc = [ArrearsMListViewController new];
//                Tc.isMyspon = YES;
//                Tc.statusString = @"5";
//                break;
//            default:
//                break;
//        }
//
//        [arr addObject:Tc];
//    }
//    return arr;
//}
@end
