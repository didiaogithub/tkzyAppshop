//
//  SCOrderManagerViewController.m
//  appmall
//
//  Created by majun on 2018/6/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCOrderManagerViewController.h"
#import "SCOrderListViewController.h"
#import "ZJScrollPageViewDelegate.h"
#import "ZJScrollPageView.h"
#import "ZJSegmentStyle.h"
@interface SCOrderManagerViewController ()<ZJScrollPageViewDelegate, ZJScrollPageViewChildVcDelegate>
{
    NSMutableArray *list;
}
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
@property (nonatomic, strong) ZJSegmentStyle *style;
@property (nonatomic, strong) NSArray *statusArr;
@end

@implementation SCOrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单列表";
     _statusArr = @[@"99", @"1", @"2", @"4,5,7", @"3,6"];
    
    [CKCNotificationCenter addObserver:self selector:@selector(jumpFK:) name:@"jumpFK" object:nil];
    list = [NSMutableArray arrayWithArray:@[@"全部",@"待付款", @"待发货", @"待收货", @"使用反馈"]];
    [self initComponents];
    
}

- (void)jumpFK:(NSNotification *)notifi{
    NSString *index = notifi.object;
    self.selectedIndex = [index integerValue];
     [_scrollPageView setSelectedIndex:self.selectedIndex animated:YES];
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
//    [_scrollPageView setBackgroundColor:[UIColor tt_grayBgColor]];
    
    [_scrollPageView setSelectedIndex:self.selectedIndex animated:YES];
    
    [self.view addSubview:_scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return list.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    SCOrderListViewController<ZJScrollPageViewChildVcDelegate> *childVc =(SCOrderListViewController *) reuseViewController;
    
    
    if (!childVc) {
        childVc = (SCOrderListViewController<ZJScrollPageViewChildVcDelegate> *)[[SCOrderListViewController alloc] init];
    }
    switch (index) {
        case 0:
            childVc = [SCOrderListViewController new];
            childVc.statusString = _statusArr[0];
            break;
        case 1:
            childVc = [SCOrderListViewController new];
            childVc.statusString = _statusArr[1];
            break;
        case 2:
            childVc = [SCOrderListViewController new];
            childVc.statusString = _statusArr[2];
            break;
        case 3:
            childVc = [SCOrderListViewController new];
            childVc.statusString = _statusArr[3];
            break;
        case 4:
            childVc = [SCOrderListViewController new];
            childVc.statusString = _statusArr[4];
            childVc.type = @"4";
            break;
        default:
                break;
    }
    return childVc;

}

-(BOOL)navigationShouldPopOnBackButton {
    if ([self.fromVC isEqualToString:@"PaySuccess"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
