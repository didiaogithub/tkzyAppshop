//
//  SCMyOrderModel.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"



@interface SCCommentOrderModel : BaseModel
/** 图片路径*/
@property (nonatomic, copy) NSString *path;
/** 规格*/
@property (nonatomic, copy) NSString *spec;
/** 数量*/
@property (nonatomic, copy) NSString *count;
/** 商品名称*/
@property (nonatomic, copy) NSString *name;
/** 商品id*/
@property (nonatomic, copy) NSString *itemid;
/** 金额*/
@property (nonatomic, copy) NSString *price;

@end



@interface SCMyOrderGoodsModel : BaseModel
/** 图片路径*/
@property (nonatomic, copy) NSString *imgurl;
/** 规格*/
@property (nonatomic, copy) NSString *itemspec;
/** 数量*/
@property (nonatomic, copy) NSString *count;
/** 商品名称*/
@property (nonatomic, copy) NSString *name;
/** 商品id*/
@property (nonatomic, copy) NSString *itemid;
/** 商品编号*/
@property (nonatomic, copy) NSString *itemno;
/** 金额*/
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *feedback;

@end



@interface SCMyOrderModel : BaseModel

/** 订单id*/
@property (nonatomic, copy) NSString *orderId;
/** 是否存在物流信息*/
@property (nonatomic, assign) NSInteger logistics;
/** 订单状态 汉字形式状态*/
@property (nonatomic, copy) NSString *orderstatuslabel;
/** 订单状态 数字形式状态*/
@property (nonatomic, copy) NSString *orderstatus;
/** 订单状态 欠款状态*/
@property (nonatomic, copy) NSString *ordertypelabel;

@property (nonatomic, copy) NSString *statusString;
/** 订单号*/
@property (nonatomic, copy) NSString *orderno;
/** 订单支付金额*/
@property (nonatomic, copy) NSString *orderpaymoney;
/** 订单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/** 订单时间*/
@property (nonatomic, strong) NSString *ordertime;

/** 订单类型（1 正常订单 2赊欠订单 3分期订单 4担保订单）*/
@property (nonatomic, copy) NSString *order_type;

@property (nonatomic, copy) NSString *feedback;

@property(nonatomic,strong)NSMutableArray <SCMyOrderGoodsModel *> *ordersheet;

@end


