//
//  SCGoodsDetailModel.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCGoodsDetailModel.h"

@implementation SCGoodsDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        _descript = value;
    }
    [super setValue:value forKey:key];
}

@end

@implementation SCGDCommentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
