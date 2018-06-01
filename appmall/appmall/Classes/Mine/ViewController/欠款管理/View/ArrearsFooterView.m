//
//  ArrearsFooterView.m
//  appmall
//
//  Created by majun on 2018/5/30.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ArrearsFooterView.h"

@implementation ArrearsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self = [super initWithFrame:frame]) {
            self = [[[NSBundle mainBundle] loadNibNamed:@"ArrearsFooterView" owner:nil options:nil] lastObject];
            
            
            self.leftBtn.layer.borderColor = [UIColor tt_borderColor].CGColor;
            self.leftBtn.layer.borderWidth = 1;
            self.leftBtn.layer.masksToBounds = YES;
            self.leftBtn.layer.cornerRadius = 3;
            self.rightBtn.layer.borderColor = [UIColor tt_redMoneyColor].CGColor;
            self.rightBtn.layer.borderWidth = 1;
            self.rightBtn.layer.masksToBounds = YES;
            self.rightBtn.layer.cornerRadius = 3;
        }
    }
    self.frame = frame;
    return self;
}



- (IBAction)actionleft:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftBtnAction:)]) {
        [self.delegate leftBtnAction:sender];
    }
}

- (IBAction)actionright:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightBtnAction:)]) {
        [self.delegate rightBtnAction:sender];
    }
}
@end
