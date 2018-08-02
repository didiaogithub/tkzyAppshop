//
//  SCCategoryGoodsModel.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseModel.h"
//imgpath = "/Uploads/201805/201805031531315aeabad3abbd1.jpg";
//itemNo = 1005;
//itemSpec = 131;
//itemid = 41;
//name = "\U5e03\U6c0f\U83cc\U75c5\U6d3b\U75ab\U82d7\Uff08S2\U682a\Uff09";
//price = "1000.00";
@interface SCCategoryGoodsModel : BaseModel
@property(nonatomic,copy)NSString * itemSpec;
@property(nonatomic,copy)NSString * itemid;
@property(nonatomic,copy)NSString * itemNo;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * imgpath;
@property(nonatomic,copy)NSString * purchaseMultiple;
@end
