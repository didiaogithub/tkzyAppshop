//
//  SCMyOrderModel.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/24.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCMyOrderModel.h"

@implementation SCCommentOrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

@implementation SCMyOrderModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"orderid"]) {
        _orderId = value;
    }
    [super setValue:value forKey:key];
}

+(NSString *)primaryKey {
    return @"orderId";
}

@end

@implementation SCMyOrderGoodsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSString *)primaryKey {
    return @"goodsKey";
}

@end
