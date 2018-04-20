//
//  DefaultValue.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/7/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultValue : NSObject

+(instancetype)shareInstance;

-(void)defaultValue;

-(id)getDefaultValue:(NSString*)key;

-(void)setDefaultValue:(NSString*)value forKey:(NSString*)key;

/** 获取所有支付方式*/
-(NSArray*)getAllPaymentMethod;
/** 获取可用的支付方式*/
-(NSArray*)getAvailablePaymentMethod;
/**配置支付方式*/
-(void)paymentAvaliable:(NSString*)value forKey:(NSString*)key;
/**域名*/
-(NSString*)domainName;
/**支付服务*/
-(NSString*)domainNamePay;
/**消息服务*/
-(NSString*)domainSmsMessage;
/**上传图片资源路径*/
-(NSString*)domainNameRes;
/**下载图片资源路径*/
-(NSString*)baseImagestr;
/**重置为默认域名*/
-(void)resetDefaultDomain;

/**银联支付服务*/
-(NSString*)domainNameUnionPay;

-(void)cleanLoginStatusCacheData;

@end


