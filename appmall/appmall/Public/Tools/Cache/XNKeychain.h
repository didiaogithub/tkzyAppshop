//
//  XNKeychain.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/7/13.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNKeychain : NSObject

+(void)setObject:(nonnull id<NSSecureCoding>)obj forKey:(nonnull NSString*)key;
+(nullable id)valueForKey:(nonnull NSString*)key;
+(void)removeObjectForKey:(nonnull NSString*)key;

@end
