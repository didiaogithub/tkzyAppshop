//
//  SCSCConfirmOrderViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//
//  从购物车进去的确认订单页面

#import "BaseViewController.h"
#import "GoodModel.h"

@interface SCSCConfirmOrderViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GoodModel *goodOrderModel;
@property (nonatomic, copy)   NSString *allMoneyString;
@property (nonatomic, copy)   NSString *typeString;

@end
