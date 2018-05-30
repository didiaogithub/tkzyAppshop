//
//  ArrearsHeaderView.m
//  appmall
//
//  Created by majun on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsHeaderView.h"

@implementation ArrearsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self = [super initWithFrame:frame]) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"ArrearsHeaderView" owner:nil options:nil] lastObject];
        }
    }
    self.frame = frame;
    return self;
}

@end
