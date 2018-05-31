//
//  GoodsDetailViewController.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "SCCategoryGoodsModel.h"

@interface GoodsDetailViewController : BaseViewController
@property (nonatomic, strong) SCCategoryGoodsModel *goodsM;
@property (nonatomic, strong) NSString  *goodsId;
-(void)loadData;
@end
