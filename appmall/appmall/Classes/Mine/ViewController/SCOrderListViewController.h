//
//  SCOrderListViewController.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/10/9.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
@interface SCOrderListViewController : BaseViewController<ZJScrollPageViewChildVcDelegate>

@property (nonatomic, copy) NSString *statusString;

@end
