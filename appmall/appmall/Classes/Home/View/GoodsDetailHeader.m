//
//  GoodsDetailHeader.m
//  appmall
//
//  Created by 阿兹尔 on 2018/5/26.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "GoodsDetailHeader.h"

@implementation GoodsDetailHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self  = [[[NSBundle mainBundle]loadNibNamed:@"GoodsDetailHeader" owner:nil options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

@end
