//
//  SCCouponTools.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCCouponTools.h"


@implementation SCCouponTools

+(instancetype)shareInstance {
    static SCCouponTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SCCouponTools alloc] initPrivate];
    });
    return instance;
}

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)deleteUsedCoupon:(NSString*)couponId {
    
}

- (void)resquestMyCouponsData {
    
    //2018.1.12增加推荐奖励图片地址为空时不请求优惠券信息的判断
    NSString *couponbgurl = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_couponbgurl"]];
    if (IsNilOrNull(couponbgurl)) return;
    
    NSString *couponCacheDate = [KUserdefaults objectForKey:@"CouponCacheDate"];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
    NSTimeInterval value = nowTime - [couponCacheDate doubleValue];
    NSLog(@"间隔------%f秒", value);
    
    NSString *coupontime = [NSString stringWithFormat:@"%@", [KUserdefaults objectForKey:@"YDSC_coupontime"]];//优惠券缓存有效时长
    if (value >= [coupontime doubleValue]) {
        [self resquestValidCouponsData];
    }
}

- (void)resquestValidCouponsData {
    
}

@end
