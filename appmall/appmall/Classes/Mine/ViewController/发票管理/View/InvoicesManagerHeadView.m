//
//  InvoicesManagerHeadView.m
//  appmall
//
//  Created by majun on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "InvoicesManagerHeadView.h"

@implementation InvoicesManagerHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self = [super initWithFrame:frame]) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"InvoicesManagerHeadView" owner:nil options:nil] lastObject];
            self.contentLabel.text = @"温馨提示：\n   1、订单完成200天，支持补开发票，订单完成60天内，支持换开发票。\n   2、个人代替公司付款，请在发票管理列表点击右上角模板";
        }
    }
    self.frame = frame;
    return self;
}

@end
