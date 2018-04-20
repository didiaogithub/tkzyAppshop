//
//  SCCouponDetailModel.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/18.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseEncodeModel.h"

@interface SCCouponDetailModel : BaseEncodeModel
/**
 订单号
 */
@property (nonatomic, copy) NSString *orderno;
/**
 收货人姓名
 */
@property (nonatomic, copy) NSString *gettername;
/**
 下单人昵称
 */
@property (nonatomic, copy) NSString *smallname;
/**
 订单金额
 */
@property (nonatomic, copy) NSString *ordermoney;
/**
 订单时间
 */
@property (nonatomic, copy) NSString *ordertime;


@end
