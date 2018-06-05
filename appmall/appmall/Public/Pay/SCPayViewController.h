//
//  SCPayViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

@interface SCPayViewController : BaseViewController
/**支付方式*/
@property (nonatomic, assign) NSInteger paymentType;
/**支付总金额*/
@property (nonatomic, copy) NSString *payfeeStr;
/**应付金额*/
@property (nonatomic, copy) NSString *money;
/**订单号*/
@property (nonatomic, copy) NSString *orderid;

@property (nonatomic, copy) NSString *enterType;

/** 是否是大礼包商品*/
@property (nonatomic, copy) NSString *isdlbitem;
/** 是否是欠款管理页面*/
@property (nonatomic, assign) BOOL isqkglPage;

@end
