//
//  ArrearsMListViewController.h
//  appmall
//
//  Created by majun on 2018/6/19.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJScrollPageViewDelegate.h"
@interface ArrearsMListViewController : BaseViewController<ZJScrollPageViewChildVcDelegate>
/**  是否选择了担保*/
@property (nonatomic, assign) BOOL isMyspon;
@property (nonatomic, copy)  NSString *statusString;
@end
