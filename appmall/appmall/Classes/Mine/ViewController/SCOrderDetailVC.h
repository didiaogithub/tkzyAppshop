//
//  SCOrderDetailVC.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/28.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

@interface SCOrderDetailVC : BaseViewController
@property (nonatomic, strong) SCMyOrderModel *orderModel;
@property (nonatomic, copy)   NSString *orderstatusString;
@property (nonatomic, copy)   NSString *orderid;
@property (nonatomic, copy)   NSString *fromVC;
/**  是否是欠款订单*/
@property (nonatomic, assign)  BOOL isqkdd;
@end
