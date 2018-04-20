//
//  SCEnterRCloudOrToothManager.m
//  TinyShoppingCenter
//
//  Created by 二壮 on 2017/10/12.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "SCEnterRCloudOrToothManager.h"


@implementation SCEnterRCloudOrToothManager

-(instancetype)initPrivate {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+(instancetype)manager {
    static SCEnterRCloudOrToothManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SCEnterRCloudOrToothManager alloc] initPrivate];
    });
    return instance;
}

-(void)enterRCloudOrTooth {
    
}

@end
