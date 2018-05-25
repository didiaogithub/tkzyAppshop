//
//  InvoicesManCellHeadView.m
//  appmall
//
//  Created by majun on 2018/5/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManCellHeadView.h"

@implementation InvoicesManCellHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"InvoicesManCellHeadView" owner:self options:nil] firstObject];
    self.frame = frame;
    return self;
}


@end
