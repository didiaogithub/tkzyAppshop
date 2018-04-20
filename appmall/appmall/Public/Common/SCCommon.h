//
//  SCCommon.h
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/8/22.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCommon : NSObject

+(BOOL)isVariableWithClass:(Class)cls varName:(NSString *)name;

+(NSString *)getCurrentDeviceModel;

+(NSString *)getWifiName;

+(NSString*)getMobileProvider;

+ (UIImage *)imageWithColor:(UIColor*)color rect:(CGRect)rect;

@end
