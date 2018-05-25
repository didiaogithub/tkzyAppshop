//
//  AddressModel.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/8/17.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEncodeModel.h"

@interface AddressModel : BaseEncodeModel

/**id*/
@property(nonatomic,copy)NSString *addressid;
/**是否是默认地址地址 是否为默认地址（0：否 1：是）*/
@property(nonatomic,copy)NSString *isdefault;
/**联系方式*/
@property(nonatomic,copy)NSString *mobile;
/**联系人*/
@property(nonatomic,copy)NSString *name;
/**详细地址*/
@property(nonatomic,copy)NSString *address;
/**省市区地址*/
@property(nonatomic,copy)NSString *provincename;
@property(nonatomic,copy)NSString *cityname;
@property(nonatomic,copy)NSString *areaname;
@property(nonatomic,copy)NSString *provincecode;
@property(nonatomic,copy)NSString *citycode;
@property(nonatomic,copy)NSString *areacode;

@end
