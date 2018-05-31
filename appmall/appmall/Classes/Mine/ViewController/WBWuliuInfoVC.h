//
//  WBWuliuInfoVC.h
//  appmall
//
//  Created by 阿兹尔 on 2018/5/31.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"

@interface WuliuModel : BaseModel
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSArray *infos;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *number;
@property (nonatomic,strong)NSString *orderNo;
@property (nonatomic,strong)NSString *paymethod;
@property (nonatomic,strong)NSString *goodNum;


@end

@interface WBWuliuInfoVC : BaseViewController
@property(nonatomic,strong)NSString *orderid;
@property(nonatomic,assign)NSInteger goodSnum;
@end
