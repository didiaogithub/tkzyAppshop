//
//  SCCommentGoodsCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOrderDetailModel.h"

@interface SCCommentGoodsCell : UITableViewCell

@property(nonatomic,strong) SCOrderDetailGoodsModel *orderDetailModel;

-(void)refreshWithDetailModel:(SCOrderDetailGoodsModel*)detailModel;


@end
