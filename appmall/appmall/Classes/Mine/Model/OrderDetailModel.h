//
//  OrderDetailModel.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"


@interface GoodSmodel : BaseModel

@property(nonatomic,strong)NSString * feedback;
@property(nonatomic,strong)NSString * itemid ;
@property(nonatomic,strong)NSString * picture ;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *specification;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,copy)NSString * itemno;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *isgift;

@end

@interface LogisticsModel : BaseModel

@property(nonatomic,strong)NSString * companyName;
@property(nonatomic,strong)NSString * number ;
@property(nonatomic,strong)NSString * info ;
@property(nonatomic,strong)NSString *time;

@end

@interface OrderDetailModel : BaseModel

@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,strong)NSString * orderNo ;
@property(nonatomic,strong)NSString * status ;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *consignee;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *totalFee;
@property(nonatomic,strong)NSString *freight;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *orderTime;
@property(nonatomic,strong)NSString *discount;
@property(nonatomic,copy)NSString * itemno;
@property(nonatomic,strong)NSString *payTime;
@property(nonatomic,strong)NSString *paytn;

@property(nonatomic,strong)NSArray <GoodSmodel *> * goods;
@property (nonatomic,strong)LogisticsModel *logistics;
-(NSString *)getOrderTitleInfo;

@end
