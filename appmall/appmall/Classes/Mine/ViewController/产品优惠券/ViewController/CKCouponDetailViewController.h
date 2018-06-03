//
//  CKCouponDetailViewController.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/16.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^CouponBlock)(NSString *price, NSString *couponId);

@protocol returnCouponDelegate <NSObject>

- (void)returnMoney:(NSString *)money couponId:(NSString*)couponId;

@end

@interface CKCouponDetailViewController : BaseViewController
@property (nonatomic, copy)   CouponBlock couponBlock;
@property (nonatomic, weak) id <returnCouponDelegate> delegate;

@property (nonatomic, assign)BOOL isMyProductLib;

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *useabelCouponArray;
@property (nonatomic, strong) NSMutableArray *unuseabelCouponArray;
@property (nonatomic, copy)   NSString *orderMoney;
@property (nonatomic, strong) NSArray *goodsIdArray;
@property (nonatomic, copy)   NSString *couponId;
@property (nonatomic, copy)   NSString *coupontMoney;
@end
