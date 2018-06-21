//
//  CKCouponCannotUseCell.h
//  CKYSPlatform
//
//  Created by majun on 2018/3/17.
//  Copyright © 2018年 ckys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CKCouponModel.h"
@protocol CKCouponCannotUseCellDelegate<NSObject>
- (void)jumpShoppingList;
@end
// 未使用
@interface CKCouponCannotUseCell : UITableViewCell
/**  立即使用*/
@property (nonatomic, strong) UIButton *usecouponBtn;
/**  dalagate*/
@property (nonatomic,weak)  id <CKCouponCannotUseCellDelegate>delegate;
-(void)refreshCouponWithCouponModel:(CKCouponModel*)couponM;
@end
