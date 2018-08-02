//
//  GoodModel.h
//  CKYSPlatform
//
//  Created by 二壮 on 16/11/15.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelRoot.h"
@interface GoodModel : BaseModelRoot
/**商品id*/
@property NSString *itemid;

/**商品名称*/
@property NSString *name;
/**价格*/
@property NSString *price;
/**图片*/
@property NSString *imgpath;
/**规格*/
@property NSString *spec;
/**加入时间*/
@property NSString *chose;
/**购买数量*/
@property(nonatomic,strong)NSString *purchaseMultiple;
@property NSString *num;
@property NSString *no;
@property BOOL isSelect;


@end

