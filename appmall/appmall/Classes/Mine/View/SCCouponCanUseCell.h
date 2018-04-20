//
//  SCCouponCanUseCell.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/15.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCouponModel.h"

@class SCCouponCanUseCell;
@protocol SCCouponCanUseDelegate <NSObject>

-(void)selectedCoupon:(UIButton*)btn couponM:(SCCouponModel*)couponM;

-(void)expandDetailContent:(SCCouponCanUseCell*)cell;

-(void)closeDetailContent:(SCCouponCanUseCell*)cell;


@end

@interface SCCouponCanUseCell : UITableViewCell

@property (nonatomic, weak) id<SCCouponCanUseDelegate> delegate;

-(void)refreshCouponWithCouponModel:(SCCouponModel*)couponM;

@end
