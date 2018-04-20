//
//  SCCouponModel.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/12/18.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCCouponModel.h"

@implementation SCCouponModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _couponid = value;
    }
    [super setValue:value forKey:key];
}

@end
