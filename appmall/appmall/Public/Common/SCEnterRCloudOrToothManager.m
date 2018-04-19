//
//  SCEnterRCloudOrToothManager.m
//  TinyShoppingCenter
//
//  Created by ForgetFairy on 2017/10/12.
//  Copyright © 2017年 ckys. All rights reserved.
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
