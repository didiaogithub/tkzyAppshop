//
//  SCOrderListCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/10/9.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//
//  订单列表页cell

#import <UIKit/UIKit.h>
#import "SCMyOrderModel.h"

@interface SCOrderListCell : UITableViewCell

- (void)refreshWithModel:(SCMyOrderGoodsModel*)model;

@end
