//
//  LogistFirstTableViewCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 17/7/27.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//
//  物流概要:"payment", "transname", "transno"

#import <UIKit/UIKit.h>
#import "LogistModel.h"

@interface LogistFirstTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *payLable;
@property (nonatomic, strong) UILabel *companyLable;
@property (nonatomic, strong) UILabel *logistLable;

-(void)refreshLogistWithModel:(LogistModel*)logistModel;

@end
