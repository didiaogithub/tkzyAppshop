//
//  SCGoodsDetailViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "SCCategoryGoodsModel.h"

@interface SCGoodsDetailViewController : BaseViewController

@property (nonatomic, strong) SCCategoryGoodsModel *goodsM;
@property (nonatomic, strong) NSString  *goodsId;

@end
