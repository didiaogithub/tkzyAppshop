//
//  SCUseCouponViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/15.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^CouponBlock)(NSString *price, NSString *couponId);

@interface SCUseCouponViewController : BaseViewController

@property (nonatomic, copy)   CouponBlock couponBlock;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *useabelCouponArray;
@property (nonatomic, strong) NSMutableArray *unuseabelCouponArray;
@property (nonatomic, copy)   NSString *orderMoney;
@property (nonatomic, strong) NSArray *goodsIdArray;
@property (nonatomic, copy)   NSString *couponId;
@property (nonatomic, copy)   NSString *coupontMoney;

@end
