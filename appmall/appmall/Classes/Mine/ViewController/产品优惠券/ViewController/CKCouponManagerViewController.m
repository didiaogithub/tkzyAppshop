//
//  CKCouponManagerViewController.m
//  appmall
//
//  Created by majun on 2018/6/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "CKCouponManagerViewController.h"
#import "CKCouponDetailViewController.h"
@interface CKCouponManagerViewController ()

{
    NSArray *list;
}
@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation CKCouponManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品券";
    
    [self segmentStyle5];
}
#pragma mark - 居中下划线
- (void)segmentStyle5 {
    list = @[@"待使用",@"已过期",@"已使用"
             ];
    _style = SegmentHeadStyleLine;
    _layout = MLMSegmentLayoutDefault;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH , 43) titles:list headStyle:_style layoutStyle:_layout];
//    _segHead.headColor = [UIColor whiteColor];
    _segHead.fontScale = 1.0;
    _segHead.fontSize = 16;
    _segHead.lineScale = .3;
    _segHead.lineColor = [UIColor tt_redMoneyColor];
    _segHead.lineHeight = 2;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = [UIColor clearColor];
    _segHead.selectColor = [UIColor tt_redMoneyColor];
    _segHead.deSelectColor = [UIColor blackColor];
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0,64 , SCREEN_WIDTH , SCREEN_HEIGHT - 64) vcOrViews:[self vcArr:list.count]];
    
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segScroll];
        [self.view addSubview:_segHead];
    }];
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        CKCouponDetailViewController *Tc;
        if (i == 0) {
            Tc = [CKCouponDetailViewController new];
            Tc.couponType = @"0";
        }else if(i == 1){
            Tc = [CKCouponDetailViewController new];
            Tc.couponType = @"2";
        }else{
            Tc = [CKCouponDetailViewController new];
            Tc.couponType = @"1";
        }
        [arr addObject:Tc];
    }
    return arr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
