//
//  CKVersionCheckManager.h
//  CKYSPlatform
//
//  Created by 二壮 on 2017/7/13.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKVersionCheckManager : NSObject

+(instancetype)shareInstance;

-(void)checkVersion;

-(void)compareVersion:(NSString*)serviceVersion forceUpdate:(NSString*)forceUpdate;

-(void)showForceUpdate;

-(BOOL)isFirstLoadCurrentVersion;

@end
