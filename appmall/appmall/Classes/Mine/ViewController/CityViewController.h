//
//  CityViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/9/14.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "SelecteAreaModel.h"
@interface CityViewController : BaseViewController
@property(nonatomic,strong)SelecteAreaModel *areaModel;
@property(nonatomic,copy)NSString *typeStr;
@end
