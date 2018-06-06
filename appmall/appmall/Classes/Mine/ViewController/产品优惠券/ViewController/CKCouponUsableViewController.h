//
//  CKCouponUsableViewController.h
//  appmall
//
//  Created by majun on 2018/6/4.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^CouponBlock)(NSString *price, NSString *couponId);
@interface CKCouponUsableViewController : BaseViewController
/**  ordermoney*/
@property (nonatomic, strong) NSString *ordermoney;
@property (nonatomic, copy)   CouponBlock couponBlock;
@end
