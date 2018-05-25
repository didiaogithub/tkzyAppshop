//
//  AddressModel.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 16/8/17.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _addressid = value;;
    }
    [super setValue:value forKey:key];
}

@end
