//
//  SCGDCommentViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/9/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "SCGoodsDetailModel.h"

@interface SCGDCommentViewController : BaseViewController

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *libcnt;
@property (nonatomic, strong) SCGoodsDetailModel *goodsDM;

@end
