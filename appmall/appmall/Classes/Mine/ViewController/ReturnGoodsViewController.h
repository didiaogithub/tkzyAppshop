//
//  ReturnGoodsViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 17/7/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "SCOrderDetailModel.h"

@interface ReturnGoodsViewController : BaseViewController

@property (nonatomic, strong) SCOrderDetailGoodsModel *detailModel;
@property (nonatomic, copy) NSString *orderid;

@end
